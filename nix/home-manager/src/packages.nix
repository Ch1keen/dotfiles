{ pkgs }:

let
  # for python
  python-with-my-packages = pkgs.python311.withPackages (import ./python-packages.nix);

  # for ruby
  ruby-with-my-packages = pkgs.ruby.withPackages (import ./ruby-packages.nix);
in [
  pkgs.fd
  pkgs.file
  pkgs.unzip
  pkgs.wget
  pkgs.cmake
  pkgs.gnumake
  pkgs.rlwrap

  # Fonts
  pkgs.d2coding
  pkgs.nerdfonts
  pkgs.nanum

  # Programming Languages
  pkgs.ghc
  python-with-my-packages
  ruby-with-my-packages
  pkgs.rustup
  pkgs.guile_3_0
  pkgs.chicken
  pkgs.nodejs

  # Hacking Related
  pkgs.one_gadget
  #pkgs.gef  # python 3.10 ropper 1.13.8 marked as broken in darwin
  pkgs.pwndbg
  pkgs.upx
  pkgs.metasploit
  #pkgs.ronin

  # Virtualisation
  pkgs.qemu
  #pkgs.cloud-utils

  # OCI(Open Container Initiative)
  pkgs.podman-compose
  pkgs.buildah
  pkgs.podman-tui

  # Eye candy
  pkgs.neofetch
  pkgs.htop
]
