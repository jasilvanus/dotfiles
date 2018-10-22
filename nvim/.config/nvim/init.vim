" call vim-plug
call plug#begin('~/.nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wincent/command-t'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-scripts/a.vim'
Plug 't9md/vim-quickhl'

call plug#end()

" lang server config
" Required for operations modifying multiple buffers like rename.
set hidden

" deoplete config
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
call deoplete#custom#option('auto_complete_delay', 5)

" languageclient cfg
let g:LanguageClient_serverCommands = {
    \ 'cpp': ['clangd'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['pyls'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>

" airline config
let g:airline_theme = "solarized"

" YouCompleteMe config
"let g:ycm_global_ycm_extra_conf = '$HOME/.vim/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf = 0

" command-T config
let g:CommandTFileScanner = "git"

" snippets config
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-x>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" quickhl config
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

" remaining config
set mouse=
set number
set hlsearch
set tabstop=3
set sw=3
set expandtab
set cursorline
syntax on

" filetype based configs
autocmd FileType tex setlocal shiftwidth=1 tabstop=1 expandtab
autocmd FileType json setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType make setlocal noexpandtab
" hack: vim detects Make.{local,config} as conf file
autocmd FileType conf setlocal noexpandtab
" for cpp, always show signcolumn to avoid jumping horizontal layout if errors
autocmd FileType cpp setlocal signcolumn=yes syntax=cpp.doxygen

" trailing whitespace handling
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" restore cursor at same position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" hotkeys
command Make !make
command SaveMake :update <bar> :Make
:map <F1> :nohls<CR>
:imap <F1> <ESC>:nohls<CR>
:map <F8> :SaveMake<CR>
:imap <F8> <ESC>:SaveMake<CR>

" alternate header / source file
:map <C-c> :A<CR>
:map <C-S-c> :AT<CR>
:imap <C-c> <ESC>:A<CR>

" faster pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" tab navigation
map <C-n> :tabn<CR>
map <C-p> :tabp<CR>

" tab control
map <C-w> :tabclose<CR>

" color profile
set background=light
colorscheme solarized
