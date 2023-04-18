{ config, pkgs, ... }:

let
  # for python
  python-with-my-packages = pkgs.python311.withPackages (import ../../src/python-packages.nix);

  # for ruby
  ruby-with-my-packages = pkgs.ruby_3_2.withPackages (import ../../src/ruby-packages.nix);
in
 {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ch1keen";
  home.homeDirectory = "/home/ch1keen";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = [
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
  ];

  imports = [
    ../../src/neovim.nix
    ../../src/tmux.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Other programs
  fonts.fontconfig.enable = true;
  programs.go.enable = true;
  programs.yt-dlp.enable = true;

  # ZSH Shell
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      "g++" = "c++";
    };
    initExtra = ''
      eval "$(direnv hook zsh)"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
	"git"
	"command-not-found"
      ];
      theme = "fino-time";
    };
  };

  # opam (OCaml)
  programs.opam = {
    enable = true;
    enableZshIntegration = true;
  };

  # rbenv
  programs.rbenv = {
    enable = true;
    enableZshIntegration = true;
    plugins = [
      {
        name = "ruby-build";
        src = pkgs.fetchFromGitHub {
          owner = "rbenv";
          repo = "ruby-build";
          rev = "v20230330";
          hash = "sha256-0v6ub6Q/IdSfNzB7vv3icpYMC8bRF0bDmlNd1Q+4sys=";
        };
      }
    ];
  };

  # nnn
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
    extraPackages = [ pkgs.viu ];
    plugins.mappings = {
      p = "preview-tui";
    };
    plugins.src = (pkgs.fetchFromGitHub {
      owner = "jarun";
      repo = "nnn";
      rev = "v4.6";
      sha256 = "sha256-+EAKOXZp1kxA2X3e16ItjPT7Sa3WZuP2oxOdXkceTIY=";
    }) + "/plugins";
  };

  # git
  programs.git.enable = true;
  programs.gitui.enable = true;
  programs.lazygit.enable = true;
  programs.git.userEmail = "gihoong7@gmail.com";
  programs.git.userName = "Ch1keen";

  # irssi
  programs.irssi.enable = true;
}
