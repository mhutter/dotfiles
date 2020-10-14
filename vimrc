scriptencoding utf-8

set nobackup
set nowritebackup
set noswapfile
set noundofile

""" Basics
set nocompatible
filetype plugin on
let g:mapleader=' '
set backupcopy=yes  " make sure inotify can pick up file changes
set backspace=2  " make sure characters can be deleted in insert mode

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
set number relativenumber

set updatetime=500
set balloondelay=250
set completeopt+=popup
set completepopup=align:menu,border:off,highlight:Pmenu

" When not in focus or in insert mode, use absolute line numbers
" otherwise, use hybrid line numbers.
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" When reopening a file, jump to the last position
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g'\"" | endif

""" Search
set hlsearch
set incsearch
set ignorecase smartcase
set smartcase

set undodir+=~/.vim/undo/
"set undofile

" remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" {{{ Plugins
" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Theme setup
Plug 'chriskempson/base16-vim'

" Go setup
Plug 'govim/govim'

" Airline & co
"Plug 'bling/vim-bufferline'
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

" Ctrl-P
Plug 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_working_path_mode = 'a'
  let g:ctrlp_custom_ignore = {
    \ 'dir': 'node_modules$',
    \ }
let g:ctrlp_user_command = [
    \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f'
    \ ]

" VimWIKI
Plug 'vimwiki/vimwiki'
  let g:vimwiki_hl_cb_checked = 1
  :nmap <Leader>wn <Plug>VimwikiNextLink
  :nmap <Leader>td <Plug>VimwikiToggleListItem

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Terraform
Plug 'hashivim/vim-terraform'
  let g:terraform_fmt_on_save=1

call plug#end()
" End Plugins }}}

set background=dark
syntax enable
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

""" Keyboard
" Remove highlights
" Clear the search buffer when hitting return
nnoremap <silent> \ :nohlsearch<cr>

" Keybindings: Switch Buffers
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

" no more arrow keys
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

" help with esc
inoremap jj <esc>
inoremap jk <esc>

" Open/Close the quickfix window
nmap <silent> <buffer> <Leader>f :execute "GOVIMQuickfixDiagnostics" | cw | if len(getqflist()) > 0 && getwininfo(win_getid())[0].quickfix == 1 | :wincmd p | endif<CR>
imap <silent> <buffer> <F2> <C-O>:execute "GOVIMQuickfixDiagnostics" | cw | if len(getqflist()) > 0 && getwininfo(win_getid())[0].quickfix == 1 | :wincmd p | endif<CR>

" Plug Update/Upgrade
command! PU PlugUpdate | PlugUpgrade

""" Filetypes:
augroup go
  nmap <buffer> <silent> <Leader>h : <C-u>call GOVIMHover()<CR>
  autocmd!
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4
  autocmd BufNewFile,BufRead *.go setlocal shiftwidth=4
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab
augroup END

autocmd BufNewFile,BufRead *.{c,cpp,h} setlocal tabstop=4
autocmd BufNewFile,BufRead *.{c,cpp,h} setlocal shiftwidth=4

autocmd BufNewFile,BufRead *.babelrc setlocal filetype=json
autocmd BufNewFile,BufRead *.sls     setlocal filetype=yaml
