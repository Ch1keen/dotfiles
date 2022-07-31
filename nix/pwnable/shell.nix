{ pkgs ? import <nixpkgs> {}
}:
  let
    mach-nix = import (builtins.fetchGit {
      url = "https://github.com/DavHau/mach-nix/";
      ref = "refs/tags/3.5.0";
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

    my-python = pkgs.python39Full;
    python-with-my-packages = my-python.withPackages (p: with p; [
      pylint
      jedi
      pwntools
      qiling
      angr
      miasm
    ]);

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
	pkgs.unzip
	pkgs.perl
        pkgs.tree
	pkgs.jdk11
        pkgs.gradle
        pkgs.bison
        pkgs.flex

        # Language for writing scripts
	python-with-my-packages
        pkgs.ruby_3_0
        pkgs.rubyPackages_3_0.pry
        one_gadget.wrappedRuby

        # NeoVim & tmux rules
        pkgs.neovim
        pkgs.tmux
        pkgs.fish

        # SymbEx
        #angr
        #miasm
	esilsolve
        
        # Emulation
        pkgs.unicorn
        pkgs.python3Packages.unicorn
        pkgs.qemu
        pkgs.qemu_full
        pkgs.qemu-utils
        pkgs.gcc_multi
        #qiling

        # Debugging or Binary analysis
        pkgs.radare2
        pkgs.ghidra-bin
        pkgs.pwndbg
	pkgs.gdb
	pkgs.apktool

        # Default Networking
        pkgs.openssh
        pkgs.netcat
      ];
      shellHook = ''
	rm -rf /tmp/gradle &> /dev/null
        mkdir /tmp/gradle 
        export GRADLE_USER_HOME="/tmp/gradle" 
        echo "org.gradle.java.home=${pkgs.jdk11}/lib/openjdk" > /tmp/gradle/gradle.properties

        r2pm update
        r2pm -ci r2ghidra
        r2pm -ci r2ghidra-sleigh
        r2pm -ci r2dec
        #r2pm -ci r2retdec
        export SHELL=$(which fish)

        tmux -f ./tmux.conf
      '';
    }
