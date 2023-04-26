{ config, pkgs, ... }:

let
  # for python
  python-with-my-packages = pkgs.python311.withPackages (import ../../src/python-packages.nix);

  # for ruby
  ruby-with-my-packages = pkgs.ruby_3_2.withPackages (import ../../src/ruby-packages.nix);

  packages = import ../../src/packages.nix { inherit pkgs; };
in
 {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hanjeongjun";
  home.homeDirectory = "/Users/hanjeongjun";

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
    # Modern Unix
    pkgs.fd
    pkgs.bat
    pkgs.bat-extras.prettybat
    pkgs.file
    pkgs.jq
    pkgs.ripgrep
    pkgs.rlwrap

    # Several Tools for writing some codes
    pkgs.opam
    pkgs.ghc
    pkgs.rustup
    pkgs.rust-analyzer
    pkgs.guile_3_0
    pkgs.chicken
    pkgs.clang-tools

    # Good fonts
    pkgs.d2coding
    pkgs.nerdfonts

    # Language Linters
    pkgs.nodePackages.pyright
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.rubyPackages.solargraph
  ];

  imports = [
    ../../src/neovim.nix
    ../../src/tmux.nix
  ];


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.go.enable = true;
  fonts.fontconfig.enable = true;

  # Oh My Zsh!
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      eval "$(rbenv init - zsh)"
      eval $(opam env)

      export PATH=$HOME/.asdf/installs/nodejs/14.21.2/bin:$PATH
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "command-not-found"
        "asdf"
      ];
      theme = "dallas";
    };
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

  programs.lazygit.enable = true;

  # I don't use rss feeds often...
  #programs.newsboat.enable = true;
  #programs.newsboat.urls = [
  #  { tags = [ "security" ]; title = "보안뉴스"; url = "http://www.boannews.com/media/news_rss.xml?mkind=1"; }
  #];
}
