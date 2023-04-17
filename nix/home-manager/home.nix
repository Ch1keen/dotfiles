{ config, pkgs, ... }:

let
  # for python
  my-python-packages = python-packages: with python-packages; [
    # Python Starter Pack
    requests
    flask

    # Python Development tools
    pylint
    autopep8

    # Hacking Related
    pwntools
  ];
  python-with-my-packages = pkgs.python310.withPackages my-python-packages;

  # for ruby
  my-ruby-packages = ruby-packages: with ruby-packages; [
    pry
    byebug
    pry-byebug

    solargraph
    rubocop
    rspec
  ];
  ruby-with-my-packages = pkgs.ruby_3_1.withPackages my-ruby-packages;
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
  home.stateVersion = "22.05";

  home.packages = [
    pkgs.fd
    pkgs.bat
    pkgs.bat-extras.prettybat
    pkgs.file
    pkgs.ripgrep
    pkgs.jq
    pkgs.tor-browser-bundle-bin
    pkgs.gparted
    pkgs.unzip
    pkgs.wget

    # Fonts
    pkgs.d2coding
    pkgs.nerdfonts
    pkgs.nanum

    # Programming Languages
    pkgs.opam
    pkgs.ghc
    pkgs.clang
    pkgs.rbenv
    python-with-my-packages
    ruby-with-my-packages
    pkgs.rustup
    pkgs.rust-analyzer
    pkgs.guile_3_0
    pkgs.chicken
    pkgs.nodejs

    # Messenger & Work
    pkgs.tdesktop
    #pkgs.slack
    #pkgs.vscode
    # slack & vscode require unfree settings, just install it manually:
    # $ NIXPKGS_ALLOW_UNFREE=1 nix-env -iA nixos.slack

    # Hacking Related
    pkgs.radare2
    pkgs.clang-analyzer
    pkgs.one_gadget
    pkgs.zap

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

  # Korean Language
  home.sessionVariables = {
    GTK_IM_MODULE = "kime";
    QT_IM_MODULE = "kime";
    QT4_IM_MODULE = "kime";
    XMODIFIERS = "@im=kime";
  };

  i18n.inputMethod.enabled = "kime";
  i18n.inputMethod.kime.config = {
    daemon = {
      modules = ["Xim" "Indicator"];
    };
    indicator = {
      icon_color = "White";
    };
    engine = {
      hangul = {
        layout = "sebeolsik-3-90";
      };
    };
    global_hotkeys.S-Space.behavior.Toggle = ["Hangul" "Latin"];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Other programs
  fonts.fontconfig.enable = true;
  programs.go.enable = true;

  # Number of editors: neovim and emacs
  programs.neovim.enable = true;
  programs.neovim.coc.enable = true;
  programs.neovim.coc.settings = {
    # Python: pyright
    "pyright.enable" = true;
    "python.linting.enabled" = true;
    "python.linting.pylintEnabled" = true;

    # Ruby: rubocop & solargraph
    "solargraph.diagnostics" = true;
  };
  programs.neovim.extraConfig = ''
    set nu
    set autoindent
    set expandtab
    set smartindent
    set cindent

    autocmd BufWritePre * :%s/\s\+$//e

    " CoC Settings
    set signcolumn=yes
    set updatetime=300

    inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice.
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif
  '';
  programs.neovim.plugins = with pkgs; [
    {
      plugin = vimPlugins.neon;
      config = "colorscheme neon";
    }

    vimPlugins.vim-airline
    vimPlugins.bufferline-nvim
    vimPlugins.nvim-ts-rainbow
    vimPlugins.vim-nix

    {
      plugin = vimPlugins.nvim-lint;
      type = "lua";
      config = ''
        require('lint').linters_by_ft = {
          nix = {'nix',},
          c = {'clangtidy'},
          cpp = {'clangtidy'}
        }

        vim.api.nvim_create_autocmd({ "InsertLeave" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      '';
    }

    {
      plugin = vimPlugins.nvim-tree-lua;
      type = "lua";
      config = ''
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup()
      '';
    }

    {
      plugin = vimPlugins.gitsigns-nvim;
      type = "lua";
      config = "require('gitsigns').setup()";
    }

    # TreeSitter
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
      plugins.tree-sitter-nix
      plugins.tree-sitter-ruby
      plugins.tree-sitter-python
      plugins.tree-sitter-javascript
      plugins.tree-sitter-typescript
      plugins.tree-sitter-tsx
      plugins.tree-sitter-c
      plugins.tree-sitter-cpp
      plugins.tree-sitter-haskell
      plugins.tree-sitter-ocaml
      plugins.tree-sitter-dockerfile
      plugins.tree-sitter-yaml
    ]))

    # CoC
    vimPlugins.coc-json
    vimPlugins.coc-clangd
    vimPlugins.coc-solargraph
    vimPlugins.coc-pyright
    vimPlugins.coc-eslint
    vimPlugins.coc-prettier
    vimPlugins.coc-rust-analyzer
  ];

  # ZSH Shell
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      eval "$(rbenv init - zsh)"
      eval $(opam env)
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

  # Tmux
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      sidebar
      {
	plugin = dracula;
	extraConfig = ''
	  set -g @dracula-show-battery true
	  set -g @dracula-show-powerline true
          set -g @dracula-show-fahrenheit false
	  set -g @dracula-refresh-rate 10
	'';
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
