" YouCompleteMe config
let g:ycm_global_ycm_extra_conf = '$HOME/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0

" command-T config
let g:CommandTFileScanner = "git"

" vundle prep
set nocompatible              " be iMproved, required
filetype off                  " required

" call vim-plug
call plug#begin('~/.vim/plugged')
if v:version >= 705
  Plug 'https://github.com/Valloric/YouCompleteMe.git'
endif
Plug 'wincent/command-t'
Plug 'vim-scripts/ultisnips'
Plug 'https://github.com/honza/vim-snippets'
" git repos on your local machine (i.e. when working on your own plugin)
" Plug 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plug 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"

" non-vundle plugins
let g:powerline_pycmd="py3"
:set laststatus=2
set rtp+=~/.powerline/bindings/vim
"
" remaining config
set mouse=
set number
set hlsearch
set tabstop=3
set expandtab
syntax on

" for some vim versions, this is required to be able to backspace across lines
set backspace=indent,eol,start

" filetype based configs
autocmd FileType tex setlocal shiftwidth=1 tabstop=1 expandtab
autocmd FileType make setlocal noexpandtab
" hack: vim detects Make.{local,config} as conf file
autocmd FileType conf setlocal noexpandtab

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

" snippets config
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<c-f>"
let g:UltiSnipsJumpForwardTrigger="<c-x>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" hotkeys
command Make !make
command SaveMake :update <bar> :Make
:map <F1> :nohls<CR>
:map <F8> :SaveMake<CR>
:imap <F8> <ESC>:SaveMake<CR>

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

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P


" color profile
set background=light
colorscheme solarized
