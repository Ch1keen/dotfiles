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
            self.IS_REMOTE = True

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
    def radare2(self, r2_cmds: str|None = None, r2_path: str|None = None):
        self.r2(r2_cmds, r2_path)

    def rz(self, rz_cmds: str|None = None):
        self.r2(r2_cmds = rz_cmds, r2_path=shutil.which('rizin'))

    def rizin(self, rz_cmds: str|None = None):
        self.r2(r2_cmds = rz_cmds, r2_path=shutil.which('rizin'))


    def r2(self, r2_cmds: str|None = None, r2_path: str|None = None):
        if isinstance(self.target, pwnlib.tubes.remote.remote):
            return

        if r2_path is None:
            # Check radare2 or rizin is available
            r2_path = shutil.which('r2') or shutil.which('radare2') or shutil.which('rizin')
            if not r2_path:
                log.failure("Cannot find where the radare2/rizin is...")
                return

        # Tmux support first
        tmux_path = shutil.which('tmux')
        if not tmux_path:
            log.failure("Cannot find where the tmux is...")
            return

        log.info("Waiting for a debugger: Radare2/Rizin...")
        pid = pwnlib.util.proc.pidof(self.target)[0]

        if r2_cmds is None:
            pwnlib.util.misc.run_in_new_terminal(f'{r2_path} -d {pid}')
            pwnlib.util.proc.wait_for_debugger(pid)
        else:
            tmpfp = NamedTemporaryFile("w", delete=False)
            # Temporarily created file will be deleted when the script is successfully loaded.
            tmpfp.write(f"!rm -f {tmpfp.name}\n" + r2_cmds.strip())
            tmpfp.flush()

            gdb_pid = pwnlib.util.misc.run_in_new_terminal(f'{r2_path} -i {tmpfp.name} -d {pid}')
            pwnlib.util.proc.wait_for_debugger(pid, gdb_pid)
            # Because it will take some time to initialize and load script,
            # close() function will be executed *right after* the radare2 or
            # rizin process was spawned.
            #
            # delete_on_close procedure will be problematic, the script won't
            # exist, already deleted, when they trying to find the script.
            tmpfp.close()


# Global functions
p32: Callable[[int], bytes] = pwnlib.util.packing.make_packer(32)
p64: Callable[[int], bytes] = pwnlib.util.packing.make_packer(64)

u32: Callable[[bytes], int] = pwnlib.util.packing.make_unpacker(32)
u64: Callable[[bytes], int] = pwnlib.util.packing.make_unpacker(64)

to_bytes: Callable[[int], bytes] = lambda x: str(x).encode()
to_hex:   Callable[[int], bytes] = lambda x: hex(x).encode()

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

