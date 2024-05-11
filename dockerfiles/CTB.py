# Pwntools
import pwnlib.elf.elf
import pwnlib.tubes
import pwnlib.util.packing
import pwnlib.util.proc
import pwnlib.util.misc
import pwnlib.context
import pwnlib.tubes
import pwnlib.ui

from pwn import log

# System
import shutil
import time
from typing import Callable
from tempfile import NamedTemporaryFile

class Ch1keenToolBox:

    def __init__(self, path: str, remote_addr: str|None = None, port: int|None = None, verbose: bool = True):
        # Context Setup
        if verbose:
            pwnlib.context.context.log_level = 'debug'
        pwnlib.context.context.binary = path

        import sys
        # Target Setup
        if len(sys.argv) == 1 or sys.argv[1] == 'local' or (port is None and remote_addr is None):
            # The target is located in the local

            e = pwnlib.elf.elf.ELF(path)
            self.target  = pwnlib.tubes.process.process(path)

        elif type(port) is int and sys.argv[1] == 'remote':
            # The target is located in the remote
            self.target = pwnlib.tubes.remote.remote(remote_addr, port)

        e = pwnlib.elf.elf.ELF(path)
        self.got     = e.got
        self.plt     = e.plt
        self.symbols = e.symbols
        self.bss     = e.bss()




    # Frequently Used Functions
    def send(self, data: bytes):
        self.target.send(data)

    def sendline(self, data: bytes):
        self.target.sendline(data)

    def sendafter(self, after_recv_it: bytes, send_it: bytes):
        self.target.sendafter(after_recv_it, send_it)

    def sendlineafter(self, after_recv_it: bytes, send_it: bytes):
        self.target.sendlineafter(after_recv_it, send_it)

    def recv(self, length: int)->bytes:
        return self.target.recv(length)

    def recvuntil(self, until_met_this: bytes)->bytes:
        return self.target.recvuntil(until_met_this)

    def interactive(self):
        return self.target.interactive()


    # Debugger
    def r2(self, r2_cmds: str|None = None):
        # Check radare2 or rizin is available
        r2_path = shutil.which('r2') or shutil.which('rz') or shutil.which('radare2') or shutil.which('rizin')
        if not r2_path:
            log.failure("Cannot find where the radare2/rizin is...")
            return

        # Tmux support first
        tmux_path = shutil.which('tmux')
        if not tmux_path:
            log.failure("Cannot find where the radare2/rizin is...")
            return

        #breakpoint()
        log.info("Waiting for a debugger: Radare2/Rizin...")
        pid = pwnlib.util.proc.pidof(self.target)[0]

        if r2_cmds is None:
            pwnlib.util.misc.run_in_new_terminal(f'r2 -d {pid}')
            pwnlib.util.proc.wait_for_debugger(pid)
        else:
            with NamedTemporaryFile("w") as tmpfp:
                tmpfp.write(r2_cmds.strip())
                tmpfp.flush()
                pwnlib.util.misc.run_in_new_terminal(f'r2 -i {tmpfp.name} -d {pid}')
                time.sleep(0.2)
                pwnlib.util.proc.wait_for_debugger(pid)


    def rz(self):
        self.r2()


# Global functions
p32: Callable[[int], bytes] = pwnlib.util.packing.make_packer(32)
p64: Callable[[int], bytes] = pwnlib.util.packing.make_packer(64)

u32: Callable[[bytes], int] = pwnlib.util.packing.make_unpacker(32)
u64: Callable[[bytes], int] = pwnlib.util.packing.make_unpacker(64)

pause = pwnlib.ui.pause


# CTB is simply an alias to the Ch1keenToolBox.
class CTB(Ch1keenToolBox):
    pass



if __name__ == '__main__':
    ctb = CTB("./prob")
    ctb.r2('''
        s main
        db main
        db sym.safe_func
        dr
    ''')
    breakpoint()

