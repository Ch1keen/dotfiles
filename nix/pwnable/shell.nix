{ pkgs ? import <nixpkgs> {}
}:
  let 
    angr = import ./angr { inherit pkgs; };
  in pkgs.mkShell {
    name="pwnable";

    buildInputs = [
     # Language for writing scripts
      pkgs.python3
      pkgs.ruby_2_7

      # NeoVim & tmux rules
      pkgs.neovim
      pkgs.tmux

      # Pwntools, itself
      pkgs.python3Packages.pwntools

      # Symbolic Execution
      angr.python3Packages.angr
    
      # Emulation
      pkgs.python3Packages.unicorn

      # Debugging or Binary analysis
      pkgs.radare2
      pkgs.python3Packages.r2pipe
      pkgs.ghidra-bin
      pkgs.gdb

      # Default Networking
      pkgs.openssh
      pkgs.netcat
    ];
    shellHook = ''
      tmux
    '';
  }
