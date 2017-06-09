scriptencoding utf-8

""" Basics
let g:mapleader=' '

""" Tabs #tabs
" - Two spaces wide
set tabstop=2
set softtabstop=2
" - Expand them all
set expandtab
" - Indent by 2 spaces by default
set shiftwidth=2

set smartindent
set smarttab

""" Format Options #format-options
set formatoptions=crq
set textwidth=80
set colorcolumn=81

""" UI Basics
" turn off mouse
set mouse=""
set title
set number

""" Search
set hlsearch
set incsearch
set ignorecase smartcase
set smartcase

if isdirectory($HOME . '/.config/nvim/undo') == 0
  :silent !mkdir -p ~/.config/nvim/undo > /dev/null 2>&1
endif
set undodir=./.vim-undo//
set undodir+=~/.vim/undo//
set undofile

" remove leading spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" Auto Install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Elixir
Plug 'elixir-lang/vim-elixir'

" Go
Plug 'fatih/vim-go'
  let g:go_fmt_command = "goimports"

" For other languages, automatically load SyntaxHighlighting
" IMPORTANT: This must be BELOW the specific Plugins above!
Plug 'sheerun/vim-polyglot'
  let g:polyglot_disabled = ['elixir', 'go']

" Run tests with varying granularity
Plug 'janko-m/vim-test'
  nmap <silent> <leader>T :TestNearest<CR>
  nmap <silent> <leader>t :TestFile<CR>
  nmap <silent> <leader>a :TestSuite<CR>
  nmap <silent> <leader>l :TestLast<CR>
  nmap <silent> <leader>g :TestVisit<CR>
  " run tests in neoterm
  let g:test#strategy = 'neoterm'

" :T
Plug 'kassio/neoterm'

" colors
Plug 'tomasr/molokai'

" Airline, cuz why not
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme = 'lucius'
  let g:bufferline_echo = 0
  let g:airline_powerline_fonts=1
  let g:airline_enable_branch=1
  let g:airline_enable_syntastic=1
  let g:airline_branch_prefix = '⎇ '
  let g:airline_paste_symbol = '∥'
  let g:airline#extensions#tabline#enabled = 0

Plug 'airblade/vim-gitgutter'

Plug 'vim-syntastic/syntastic'
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_javascript_checkers = ['standard']
  let g:syntastic_html_checkers = []

call plug#end()

set background=dark
syntax enable
colorscheme molokai

""" Keyboard
" Remove highlights
" Clear the search buffer when hitting return
nnoremap <silent> <cr> :nohlsearch<cr>

" hide/close terminal
nnoremap <silent> ,th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> ,tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> ,tc :call neoterm#kill()<cr>

" Keybindings: Switch Buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

" no more arrow keys
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

" Plug Update/Upgrade
command! PU PlugUpdate | PlugUpgrade

""" Filetypes:
augroup go
  autocmd!
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4
  autocmd BufNewFile,BufRead *.go setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab
augroup END

autocmd BufNewFile,BufRead *.babelrc setlocal filetype=json
