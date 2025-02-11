""" Basics
set nocompatible
set encoding=utf-8

" Map leader to space
"let g:mapleader=','

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
"set backupcopy=yes
set nobackup
set nowritebackup


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
"Plug 'tanvirtin/monokai.nvim'
Plug 'sainnhe/sonokai'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme = 'sonokai'
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

" Terraform
Plug 'hashivim/vim-terraform'

" TODO: vim-ale

call plug#end()

""" Theme setup
set background=dark
"set termguicolors
colorscheme sonokai

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

"""
""" CoC Configuration
"""

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR>
    \ coc#pum#visible() ? coc#pum#confirm() :
    \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting entire document
xmap <leader>f  <Plug>(coc-format)
nmap <leader>f  <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Jumping between placeholders is ^j and ^k
augroup end

" Remap keys for applying codeAction to the current buffer.
nmap <leader>a  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>.  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OI` command for organize imports of the current buffer.
command! -nargs=0 OI :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
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

" Disable CoC for certain filetypes
autocmd BufNew,BufEnter *.md execute "silent! CocDisable"
autocmd BufLeave *.md execute "silent! CocEnable"

"""
""" End CoC Configuration
"""
