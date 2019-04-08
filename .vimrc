" YouCompleteMe config
let g:ycm_global_ycm_extra_conf = '$HOME/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0

" command-T config
let g:CommandTFileScanner = "git"

" vundle prep
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"
if v:version >= 705
  Plugin 'https://github.com/Valloric/YouCompleteMe.git'
endif
Plugin 'wincent/command-t'
Plugin 'ultisnips'
Plugin 'https://github.com/honza/vim-snippets'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

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
