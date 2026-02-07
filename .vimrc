" Set leader key
let mapleader = " "

" ===== fbterm-safe Vim colors =====
if &term =~# 'fbterm'
  set t_Co=256
  set background=dark
  syntax on
  colorscheme desert
endif


" Basic settings
set number
set relativenumber
" set cursorline
" set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set wrap
set scrolloff=8
set colorcolumn=75
" set termguicolors
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
set wildmode=longest:full,full
set wildoptions=pum
set wildignorecase

" Autocomplete from files and buffers
set omnifunc=lsp#syntaxcomplete#Complete
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

" Escape from insert mode disable this for now
"inoremap jk <Esc>
"inoremap JK <Esc>

" Disable arrow keys
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>



" Yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Delete without yanking (black hole register)
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Disable Q
nnoremap Q <nop>

" Change buffers with Shift-h / Shift-l
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>

" Quickfix list mappings only inside quickfix window
augroup qf_maps
  autocmd!
  autocmd FileType qf nnoremap <buffer> <silent> <C-n> :cn<CR>|wincmd p<CR>
  autocmd FileType qf nnoremap <buffer> <silent> <C-p> :cN<CR>|wincmd p<CR>
augroup END

" (Optional) If you truly want to remove <C-n> in Normal mode globally:
" (Note: this will also remove default search-next-char completion behavior in some setups)
" silent! nunmap <C-n>

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
colorscheme default

" Transparency
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE


augroup spell_checker
    " Clear existing autocmds in the group
    autocmd! spell_checker
    autocmd FileType markdown,txt setlocal spell spelllang=en_us
augroup END


""""" PLUGISN SECTION  

" for install vim plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


" ---------------------------
" Plugins
" ---------------------------
call plug#begin('~/.vim/plugged')

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Completion (cmp-like for Vim)
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Optional extra completion sources
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'

call plug#end()


" some shoutcuts
" Trigger completion manually (your existing mapping is fine)
inoremap <C-Space> <C-x><C-o>

" Optional: use Tab / Shift-Tab to navigate completion menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"

" LSP keybinds (optional but useful)
nnoremap gd :LspDefinition<CR>
nnoremap gr :LspReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap <leader>rn :LspRename<CR>
nnoremap <leader>ca :LspCodeAction<CR>
