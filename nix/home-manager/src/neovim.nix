{ pkgs, ... }:

{
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
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
}
