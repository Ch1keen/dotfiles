{ pkgs }:

let
  # for python
  python-with-my-packages = pkgs.python311.withPackages (import ./python-packages.nix);

  # for ruby
  ruby-with-my-packages = pkgs.ruby_3_2.withPackages (import ./ruby-packages.nix);
in [
  pkgs.fd
  pkgs.bat
  pkgs.bat-extras.prettybat
  pkgs.file
  pkgs.ripgrep
  pkgs.jq
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
  pkgs.clang
  python-with-my-packages
  ruby-with-my-packages
  pkgs.rustup
  pkgs.rust-analyzer
  pkgs.guile_3_0
  pkgs.chicken
  pkgs.nodejs

  # Hacking Related
  pkgs.radare2
  pkgs.clang-analyzer
  pkgs.one_gadget
  pkgs.gef
  pkgs.pwndbg

  # Virtualisation
  pkgs.qemu-utils
  pkgs.cloud-utils

  # OCI(Open Container Initiative)
  pkgs.podman-compose
  pkgs.buildah
  pkgs.podman-tui

  # Linter & LSP
  pkgs.clang-tools

  # Eye candy
  pkgs.neofetch
  pkgs.htop
]
