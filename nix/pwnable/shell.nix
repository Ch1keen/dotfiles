{ pkgs ? import <nixpkgs> {}
}:
  let
    mach-nix = import (builtins.fetchGit {
      url = "https://github.com/DavHau/mach-nix/";
      ref = "refs/tags/3.3.0";
    }) {};
    angr = mach-nix.mkPython {
        python = "python39Full";
        requirements = ''
          angr
        '';
      };
    miasm = mach-nix.mkPython {
        python = "python39Full";
        requirements = ''
          miasm
        '';
      };
    qiling = mach-nix.mkPython {
        python = "python39Full";
        requirements = ''
          qiling
        '';
      };

  in
    pkgs.mkShell {
      name="pwnable";

      buildInputs = [
        # Meta
        pkgs.glibcLocales
        pkgs.cmake

        # Language for writing scripts
        pkgs.python39Full
        pkgs.python39Packages.pylint
        pkgs.ruby_3_0
        pkgs.rubyPackages_3_0.pry

        # NeoVim & tmux rules
        pkgs.neovim
        pkgs.tmux
        pkgs.fish

        # Pwntools, itself
        pkgs.python39Packages.pwntools

        # Angr
        angr
        miasm
        
        # Emulation
        pkgs.unicorn
        pkgs.python3Packages.unicorn
        pkgs.qemu_full
        qiling

        # Debugging or Binary analysis
        pkgs.radare2
        pkgs.ghidra-bin
        pkgs.pwndbg

        # Default Networking
        pkgs.openssh
        pkgs.netcat

        pkgs.tree
      ];
      shellHook = ''
        r2pm update
        r2pm -i r2ghidra
        r2pm -ci r2dec
        export SHELL=$(which fish)

        tmux -2
      '';
    }
