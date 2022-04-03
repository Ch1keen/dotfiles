{ pkgs ? import <nixpkgs> {}
}:
  let
    mach-nix = import (builtins.fetchGit {
      url = "https://github.com/DavHau/mach-nix/";
      ref = "refs/tags/3.4.0";
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
    one_gadget = pkgs.bundlerEnv {
        name = "one_gadget";
        gemdir = ./.;
      };
    esilsolve = import ./esilsolve.nix;

  in
    pkgs.mkShell {
      name="pwnable";

      buildInputs = [
        # Meta
        pkgs.glibcLocales
        pkgs.cmake
        pkgs.which
        pkgs.git
        pkgs.cacert
        pkgs.openssl
	pkgs.bat
	pkgs.fd

        # Language for writing scripts
        pkgs.python39Full
        pkgs.python39Packages.pylint
        pkgs.python39Packages.jedi
        pkgs.ruby_3_0
        pkgs.rubyPackages_3_0.pry
        one_gadget.wrappedRuby

        # NeoVim & tmux rules
        pkgs.neovim
        pkgs.tmux
        pkgs.fish

        # Pwntools, itself
        pkgs.python39Packages.pwntools

        # SymbEx
        angr
        miasm
	esilsolve
        
        # Emulation
        pkgs.unicorn
        pkgs.python3Packages.unicorn
        pkgs.qemu
        pkgs.qemu_full
        pkgs.qemu-utils
        pkgs.gcc_multi
        qiling

        # Debugging or Binary analysis
        pkgs.radare2
        pkgs.ghidra-bin
        pkgs.pwndbg
	pkgs.apktool

        # Default Networking
        pkgs.openssh
        pkgs.netcat
        pkgs.tree
      ];
      shellHook = ''
        r2pm update
        r2pm -i r2ghidra
        r2pm -ci r2dec
        #r2pm -ci r2retdec
        export SHELL=$(which fish)

        tmux -f ./tmux.conf
      '';
    }
