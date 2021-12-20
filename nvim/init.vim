call plug#begin()
" nord Theme
Plug 'shaunsingh/nord.nvim'

" Beautiful Statusline
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" CoC
" https://developpaper.com/complete-guide-to-getting-started-with-coc-nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" nvim-autopairs
" https://github.com/windwp/nvim-autopairs
lua require('nvim-autopairs').setup{}

" lua-line
lua << EOF
require('lualine').setup{
  options = {
    icons_enabled = true,
    theme = 'nord'
  }
}
EOF

colorscheme nord

set encoding=utf-8
set number
set relativenumber

" tab indentation
" https://stackoverflow.com/questions/51995128/setting-autoindentation-to-spaces-in-neovim
set autoindent
set expandtab
set tabstop=8 softtabstop=2 shiftwidth=2
set smartindent

