""" Basics
set nocompatible
set encoding=utf-8

" Map leader to space
let g:mapleader= ' '


" keep buffers loaded when not visible to allow them to be edited
set hidden

" More space for commands & output
set cmdheight=2

" Write swapfile (& trigger plugins) earlier
set updatetime=300

" less noisy completions
set shortmess+=c

" display signs in numbers column
set signcolumn=number

" fold using markers
set foldmethod=marker


""" Tabs
" two spaces wide
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2

set smartindent
set smarttab


""" File types
au! BufRead,BufNewFile .envrc setfiletype sh

""" Formatting
set textwidth=80
set colorcolumn=81
""" ... but disable wrapping for certain file types
au FileType asciidoc set textwidth=0
au FileType markdown set textwidth=0

""" Line numbers
set number relativenumber
" when not in focus or insert mode, use absolute line mubers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


""" Search
set hlsearch
set incsearch
set ignorecase
set smartcase


" Solve issues with tools that watch a folder
set backupcopy=yes


""" Functionality

" When reopening a file, jump to last position
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g'\"" | endif

" remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" permanent undo
set undodir=~/.vimdid
set undofile


""" Plugins
call plug#begin('~/.local/share/nvim/plugged')
"Plug 'chriskempson/base16-vim'
Plug 'tanvirtin/monokai.nvim'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme = 'lucius'
  let g:bufferline_echo = 0
  let g:airline_powerline_fonts=1
  let g:airline_enable_branch=1
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

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-go',
    \ 'coc-html',
    \ 'coc-rust-analyzer',
    \ 'coc-toml'
    \ ]

" Jsonnet
Plug 'google/vim-jsonnet'
let g:jsonnet_fmt_options = '--pad-arrays'

" Terraform
Plug 'hashivim/vim-terraform'

" TODO: vim-ale

call plug#end()

""" Theme setup
set background=dark
"let base16colorspace=256
colorscheme monokai
set termguicolors

""" Keybindings
" Plug Update & Upgrade
command! PU PlugUpdate | PlugUpgrade

" no more arrow keys
map <Left>  :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up>    :echo "no!"<cr>
map <Down>  :echo "no!"<cr>

" clear search results
nnoremap <silent> \ :nohlsearch<cr>

" Switch buffers
nnoremap <tab> :bnext<cr>
nnoremap <s-tab> :bprevious<cr>

" Use tab to trigger completion with characters
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completions
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter
inoremap <silent><expr> <cr>
  \ pumvisible() ?
  \ coc#_select_confirm() :
  \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" (Go) Add missing imports on save
autocmd BufWritePre *.{rs,go} :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f <Plug>(coc-format)
nmap <leader>f <Plug>(coc-format)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>. <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl <Plug>(coc-codelens-action)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"


" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>A  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>C  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


""" Commands
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OI` command for organize imports of the current buffer.
command! -nargs=0 OI :call CocActionAsync('runCommand', 'editor.action.organizeImport')
