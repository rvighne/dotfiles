" Extend rather than replace Vim 8 defaults
source $VIMRUNTIME/defaults.vim

" Overrides for Git for Windows
set wildmode&

" Requires a true-color theme
set termguicolors

" Background detection fails in Windows Terminal
set background=dark

" More GUI-like behavior
set title belloff=all lazyredraw

" Continuous pane boundary
set fillchars+=vert:│

" Main options
set hidden autowrite
set showmatch
set spell complete+=k
set backspace=indent
set autoindent shiftwidth=0 tabstop=4
set ignorecase smartcase hlsearch
set splitbelow splitright
set number cursorline
set linebreak breakindent showbreak=↳\ \ \ "
set foldmethod=syntax
set clipboard=unnamed
set printoptions=formfeed:y

" Mode-dependent cursor shape
set t_SI=[5\ q
set t_SR=[3\ q
set t_EI=[1\ q

" Reset cursor to terminal default on exit
autocmd VimLeave * set t_me=[0\ q

" Why isn't this default
noremap Y y$

" Shift-less command mode
noremap ; :
tnoremap ; :

" Speedy buffer switching
noremap <CR> :buf<SPACE>
noremap <SPACE> :b#<CR>

" Speedy window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Use LaTeX distro to print as PDF
command Pdf hardcopy >%.ps | !ps2pdf %.ps<CR>

" Colorscheme to match terminal (One Half Dark)
let g:one_allow_italics = 1
colorscheme one

" Font with builtin glyphs: Fira Code (normal weight)
let g:airline_powerline_fonts = 1

" Show numbered buffers in airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

" Redundant with airline
set noshowmode
