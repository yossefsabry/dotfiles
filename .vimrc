" Set leader key
let mapleader = " "

" Basic settings
set number
set relativenumber
set cursorline
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set wrap
set scrolloff=8
set colorcolumn=75
set termguicolors
set wildignore+=**/node_modules/**
set wildignore+=**/vendor/**
set wildignore+=**/lib/**
set wildignore+=**/venv/**
set path=.,**
set undofile
set hlsearch
set incsearch
set noswapfile
set updatetime=10


" Enable keyword completion with Ctrl+N and Ctrl+P
set completeopt=menuone,noinsert,noselect
set wildmenu

" Autocomplete from files and buffers
set omnifunc=syntaxcomplete#Complete
set complete+=k
set complete+=.

" Key mappings for easier completion
inoremap <C-Space> <C-x><C-o>


" Netrw settings
let g:netrw_browse_split = 0
let g:netrw_banner = 1
let g:netrw_winsize = 1
let g:netrw_liststyle = 1

" Key mappings
" Scrolling centers cursor
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap G Gzz

" Indenting in visual mode
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" File explorer
nnoremap <leader>e :vertical Ex<CR>

" Resize splits
nnoremap <C-Up> :resize +4<CR>
nnoremap <C-Down> :resize -4<CR>
nnoremap <C-Left> :vertical resize -4<CR>
nnoremap <C-Right> :vertical resize +4<CR>

" Navigate buffers
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Escape from insert mode
inoremap jk <Esc>
inoremap JK <Esc>

" Disable arrow keys
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>

" Yanking and pasting
" Yanking and pasting to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
xnoremap <leader>p "+p
vnoremap <leader>d "_d

" for auto vsplit files equls
autocmd WinNew * wincmd =

" Quickfix navigation
autocmd FileType qf nnoremap <buffer> <C-n> :cn<CR>|wincmd p<CR>
autocmd FileType qf nnoremap <buffer> <C-p> :cN<CR>|wincmd p<CR>

" Create folds
nnoremap <leader>z zfaB

" Make files executable
nnoremap <leader>x :!chmod +x %<CR>

" Disable Q
nnoremap Q <nop>

" Syntax highlighting
syntax on
set termguicolors
colorscheme desert

" Transparency
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE

