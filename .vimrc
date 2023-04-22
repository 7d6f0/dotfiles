set encoding=utf-8
filetype off
filetype plugin indent off

" vim-plug
call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'osyo-manga/vim-anzu'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'bronson/vim-trailing-whitespace'
  Plug 'thinca/vim-zenspace'
  Plug 'ghifarit53/tokyonight-vim'
  if v:version >= 800
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
  endif
call plug#end()

" default
syntax enable
set cursorline
hi clear CursorLine
set number
set showmatch
set matchtime=1
set shiftwidth=4
set autoindent
set smartindent
set splitright
set splitbelow
set nobackup
set noswapfile
set hlsearch
set hidden
set incsearch
set ignorecase
set smartcase
set laststatus=2
set showcmd
set backspace=indent,eol,start
set scrolloff=3
set clipboard+=unnamed
set showtabline=2
set vb t_vb=
set list
set listchars=tab:>-
set t_Co=256
set termguicolors

" remap
let mapleader = "\<Space>"
nnoremap <silent> Y y$
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>
nnoremap <silent> ; :Buffers<CR>
nnoremap <Leader>d :Gdiff<CR>
inoremap <C-e> <END>
inoremap <C-a> <HOME>

" fzf
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>r :Rg<CR>

" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" lsp
if v:version >= 800
  let g:lsp_diagnostics_echo_cursor = 1
  nmap <Leader>p <Plug>(lsp-peek-definition)
  nmap <Leader>j <Plug>(lsp-definition)
  nmap <Leader>v :vsplit<CR><Plug>(lsp-definition)
  nmap <Leader>s :split<CR><Plug>(lsp-definition)
  autocmd BufWritePre <buffer> LspDocumentFormatSync
endif

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='tokyonight'

" colorscheme
colorscheme tokyonight

filetype plugin indent on
