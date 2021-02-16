{ pkgs ? import <nixpkgs> {}
}:
  let archinfo = pkgs.python39Packages.buildPythonPackage rec {
      pname = "archinfo";
      version = "9.0.5171";
      src = pkgs.python39Packages.fetchPypi {
        inherit pname;
        inherit version;
    	sha256 = "1va6wyg586md14j9gblwfj0y87cr35qxa3vriadhwq7h5sx0b31j";
      };
      
      buildInputs = [ pkgs.python39Packages.setuptools ];
      
      # archinfo can't pass setuptools test
      doCheck = false;
    };
  in
  let pyvex = pkgs.python39Packages.buildPythonPackage rec {
      pname = "pyvex";
      version = "9.0.5171";
      src = pkgs.python39Packages.fetchPypi {
        inherit pname;
        inherit version;
    	sha256 = "0906vq3fbzl06wvfgkhry484nnkma01s8jnhfc55v1qpaxhm3ldp";
      };
        
      buildInputs = [
        pkgs.python39Packages.cffi
        pkgs.python39Packages.future
        pkgs.python39Packages.bitstring
        archinfo
      ];
    };
    
    unicorn = pkgs.python39Packages.buildPythonPackage rec {
      pname = "unicorn";
      version = "1.0.2rc4";
      src = pkgs.python39Packages.fetchPypi {
        inherit pname;
        inherit version;
    	sha256 = "10a7pp9g564kqqinal7s8ainbw2vkw0qyiq827k4j3kny9h4japd";
      };
    };
    
    ailment = pkgs.python39Packages.buildPythonPackage rec {
      pname = "ailment";
      version = "9.0.5171";
      src = pkgs.python39Packages.fetchPypi {
        inherit pname;
        inherit version;
    	sha256 = "0i4k1p3l9zq24xxm9jgba0p9w95pkdhkm4hxyx2qcjz4zp5q8cvb";
      };
      buildInputs = [
        pyvex
        archinfo
        pkgs.python39Packages.future
        pkgs.python39Packages.cffi
        pkgs.python39Packages.bitstring
      ];
    };
    
  in 
  let angr = pkgs.python39Packages.buildPythonPackage rec {
    pname = "angr";
    version = "9.0.5171";
    src = pkgs.python39Packages.fetchPypi {
      inherit pname;
      inherit version;
      sha256 = "1g43kiw67s8jspkwh8mq4fh9r93ckq4g32xh4c5k4zvf10aiphbf";
    };
      
    buildInputs = [
      pyvex
      unicorn
      archinfo
      ailment
      pkgs.python39Packages.pycparser
      pkgs.python39Packages.cffi
      pkgs.python39Packages.future
      pkgs.python39Packages.bitstring
    ];
  };
  in pkgs.mkShell {
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
      angr

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
