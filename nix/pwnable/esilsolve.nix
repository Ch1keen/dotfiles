with import <nixpkgs> {};
with pkgs.python39Packages;

let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix";
    ref = "refs/tags/3.4.0";
  }) {};

  depends = mach-nix.mkPython {
    python = "python39Full";
      requirements = ''
      z3-solver
      pyvex
      capstone
    '';
  };

in
  buildPythonApplication rec {
    name = "esilsolve";
    version = "git-220127";

    src = pkgs.fetchFromGitHub {
      owner  = "radareorg";
      repo   = "esilsolve";
      rev    = "b232e061014f86dc04a1d8d60f464f623c8ef51a";
      sha256 = "1lqpryz3v4cpfffhi80pb0lz4r74pm03xhhaybbz9yavmvfcz8gd";
    };

    propagatedBuildInputs = [ 
      pkgs.python39Packages.colorama
      pkgs.python39Packages.r2pipe
      depends
    ];
  }

