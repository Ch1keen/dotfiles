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
    
    # Python Packages for Crypto
    pkgs.python39Packages.pycrypto
    
    # Ruby Packages for Crypto

    # Pwntools, itself contains awesome crypto tools
    pkgs.python39Packages.pwntools

    # Default Networking
    pkgs.openssh
  ];
  shellHook = ''
    echo "Live how you want!"
    
    echo "To-do List:"
    echo " - chepy"
  '';
}
