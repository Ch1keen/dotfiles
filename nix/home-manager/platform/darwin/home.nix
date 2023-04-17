{ config, pkgs, ... }:

let
  # for Python
  python-with-my-packages = pkgs.python311.withPackages (import ../../src/python-packages.nix);

  # for Ruby
  ruby-with-my-packages = pkgs.ruby_3_1.withPackages (import ../../src/ruby-packages.nix);
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



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.go.enable = true;
  fonts.fontconfig.enable = true;

  programs.neovim.enable = true;
  programs.neovim.coc.enable = true;
  programs.neovim.coc.settings = {
    # Python: pyright
    "pyright.enable" = true;
    "python.linting.enabled" = true;
    "python.linting.pylintEnabled" = true;

    # Ruby: rubocop and solargraph
    "solargraph.diagnostics" = true;

    # Clang++
    "clangd.arguments" = [ "--clang-tidy" ];
    "clangd.fallbackFlags" = [ "-std=c++17" ];

  };
  programs.neovim.extraConfig = ''
    set nu

    " Indentation
    " https://stackoverflow.com/questions/51995128/setting-autoindentation-to-spaces-in-neovim
    set autoindent
    set expandtab
    set smartindent
    set cindent
    set tabstop=2
    set shiftwidth=0
    filetype plugin indent on

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

    " GoTo code navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    " Symbol renaming
    nmap <leader>rn <Plug>(coc-rename)
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
      plugin = vimPlugins.telescope-nvim;
      type = "lua";
      config = ''
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
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

  programs.tmux = {
    enable = true;
    tmuxinator.enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    extraConfig = "set -g mouse on";
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

  programs.lazygit.enable = true;

  # I don't use rss feeds often...
  #programs.newsboat.enable = true;
  #programs.newsboat.urls = [
  #  { tags = [ "security" ]; title = "보안뉴스"; url = "http://www.boannews.com/media/news_rss.xml?mkind=1"; }
  #];
}
