{ pkgs ? import <nixpkgs> {}
}:
pkgs.mkShell {
  name="pwnable";
  buildInputs = [
    # Language for writing scripts
    pkgs.python37
    pkgs.ruby_2_7

    # NeoVim rules
    pkgs.neovim

    # Pwntools, itself
    pkgs.python37Packages.pwntools

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
  '';
}
