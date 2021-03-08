{ pkgs ? import <nixpkgs> {}
}:
  pkgs.mkShell {
    name="pwnable";
    buildInputs = [
     # Language for writing scripts
      pkgs.python39
      pkgs.ruby_2_7

      # NeoVim & tmux rules
      pkgs.neovim
      pkgs.tmux

      # Pwntools, itself
      pkgs.python39Packages.pwntools
    
      # Emulation
      pkgs.python39Packages.unicorn

      # Debugging or Binary analysis
      pkgs.radare2
      pkgs.ghidra-bin
      pkgs.gdb

      # Default Networking
      pkgs.openssh
      pkgs.netcat
    ];
    shellHook = ''
      echo "Live how you want!"
    
      echo "To-do List:"
      echo " - angr"
      echo " - miasm"
      echo " - gef"
    '';
  }
