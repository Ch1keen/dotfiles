{ pkgs ? import <nixpkgs> {}
}:
  pkgs.mkShell {
    name="pwnable";

    buildInputs = [
      # Language for writing scripts
      pkgs.python39Full
      pkgs.ruby_3_0

      # NeoVim & tmux rules
      pkgs.neovim
      pkgs.tmux

      # Pwntools, itself
      pkgs.python39Packages.pwntools

      # Angr
      (let
        mach-nix = import (builtins.fetchGit {
          url = "https://github.com/DavHau/mach-nix/";
          ref = "refs/tags/3.3.0";
        }) {};
      in
        mach-nix.mkPython {
          requirements = ''
            angr
	  '';
	}
      )

      # Emulation
      pkgs.unicorn
      pkgs.python3Packages.unicorn

      # Debugging or Binary analysis
      pkgs.rizin
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
