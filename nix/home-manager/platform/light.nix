{ config, pkgs, ... }:

let
  basic_packages = import ../src/packages.nix { inherit pkgs; };
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

  home.packages = basic_packages;

  imports = [
    ../src/neovim.nix
    #../src/my-nixvim.nix
    ../src/tmux.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Other programs
  fonts.fontconfig.enable = true;
  programs.go.enable = true;
  programs.yt-dlp.enable = true;

  # ZSH Shell
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "g++" = "c++";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "command-not-found"
      ];
      theme = "fino-time";
    };
  };

  # Modern Unix
  programs.bat.enable = true;
  programs.bat.extraPackages = with pkgs.bat-extras; [ batgrep prettybat ];
  programs.ripgrep.enable = true;
  programs.jq.enable = true;
  programs.eza.enable = true;
  programs.eza.enableZshIntegration = true;
  programs.eza.icons = true;
  programs.less.enable = true;

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
  programs.lazygit.enable = true;
  programs.gitui.enable = true;

  programs.git.userEmail = "gihoong7@gmail.com";
  programs.git.userName = "Ch1keen";
  programs.git.delta.enable = true;

  # irssi
  programs.irssi.enable = true;
}
