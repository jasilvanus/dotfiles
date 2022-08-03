if [ -e "${HOME}/bin/zsh" ] && [ -z "${_ZSH_USE_OVERRIDE_ZSH}" ];
then
   export _ZSH_USE_OVERRIDE_ZSH=1
   exec ${HOME}/bin/zsh
fi
unset _ZSH_USE_OVERRIDE_ZSH

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -z "${SOURCED_DOT_PROFILE}" ]; then
   source ~/.profile
fi

if [ -e "${HOME}/.zshrc.local" ]; then
   source "${HOME}/.zshrc.local"
fi

# low level version compare, used to check if we skip most of this for old zshs
# Given two version strings, returns the larger of the two.
# relies on sort -V
larger_version() {
   echo "
${1}
${2}
" | sort -V | tail -1
}

if [ "$(larger_version ${ZSH_VERSION} 5.1)" = "5.1" ]
then
   export PS1='%F%B%n%f@%m %F%~: %f%b'
   echo "Old zsh detected, using fallback config!"
   return
fi

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' menu select

autoload -Uz compinit

# Only regenerate .zcompdump every 24h to speed up startup time
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

# End of lines added by compinstall
# Lines configured by zsh-newuser-install

##############################################################################
# History Configuration
##############################################################################
HISTSIZE=100000               #How many lines of history to keep in memory
HISTFILE=~/.histfile         #Where to save history to disk
SAVEHIST=$HISTSIZE               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt    hist_ignore_all_dups #Ignore duplicates in history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

bindkey '^[OA' up-line-or-history     # Cursor up
bindkey '^[OB' down-line-or-history   # Cursor down
bindkey '^[[1;5A' up-line-or-local-history    # [CTRL] + Cursor up
bindkey '^[[1;5B' down-line-or-local-history  # [CTRL] + Cursor down

# Other config

setopt autocd
setopt interactivecomments
# no beeps
unsetopt beep

# End of lines configured by zsh-newuser-install

# Edit current line in vim
autoload -U edit-command-line
# # Emacs style
# bindkey -e

# Vim style
bindkey -v

# ctrl-x-e launches ${EDITOR} to edit the current line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
bindkey -M vicmd '^xe' edit-command-line
bindkey -M vicmd '^x^e' edit-command-line

# custom hotkeys
# use ctrl+arrow to navigate words
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# bind alt-arrow to move-word-until-non-alpha
backward-dir () {
   local WORDCHARS=${WORDCHARS/\/}
   zle backward-word
}
zle -N backward-dir
bindkey "^[[1;3D" backward-dir
forward-dir () {
   local WORDCHARS=${WORDCHARS/\/}
   zle forward-word
}
zle -N forward-dir
bindkey "^[[1;3C" forward-dir

# bind alt-backspace to delete-word-until-non-alpha
backward-kill-dir () {
   local WORDCHARS=${WORDCHARS/\/}
   zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir

#################
# Aliases
#################
alias ..='cd ..'
alias aptns='SKIP_AUTOSNAP=YES apt' # requires sudo alias expansion to be useful
alias bc='bc -l'
alias g='git'
alias gdb='gdb -q' # disables pagination. cannot be done in .gdbinit because it is read AFTER first printing
alias cgdb='cgdb -q'
#alias glances='glances --theme-white'
alias less='less -S'
# alias lr='ls -latrh'
alias ls='ls --color=auto'
alias l='exa'
alias lr='exa --git -l --color-scale  -s date'
alias la='exa --git -l --color-scale  -s date --all'
alias grep='grep --color=auto'
alias lt='ls -tr'
alias open='xdg-open'
alias time='/usr/bin/time'
alias nv='nvim'
# intended to be used as 'fzr **<TAB>' because plain '**<TAB>' does not work
alias fzr='command'
alias sudo='sudo ' # allow alias expansion for sudo

alias tmux_ttys='tmux list-panes -aF "#{pane_tty}, window #{window_index}, pane #{pane_index}"'
alias vlc='vlc -q'
alias kxdot='pkill xdg-open; pkill xdot'

#################
# Functions
#################

rlf() { readlink -f ${@}; }

pushj() { pushd .; j $@; }
popj() { popd; }

################
# Tools
################

# dircolors
if [ -e "${HOME}/.dir_colors" ];
then
   eval `dircolors ${HOME}/.dir_colors`
else
   echo "Missing ~/.dir_colors symlink, using default colors"
fi

# autojump support
if [ -z "${DF_AUTOJUMP}" ] && [ -e ~/.autojump-shell-base ]; then
  DF_AUTOJUMP=~/.autojump-shell-base
  ZSH_AUTOJUMP=${DF_AUTOJUMP}/autojump.zsh
fi
if [ ! -z "${ZSH_AUTOJUMP}" ] && [ -e "${ZSH_AUTOJUMP}" ]; then
  . ${ZSH_AUTOJUMP}
fi

# custom autojump function: without arguments, launch fzf
j() {
    if [[ "$#" -ne 0 ]]; then
        cd $(autojump $@)
        return
    fi
    cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { print $(i) } }' |  fzf --height 40% --reverse --inline-info)"
}

# powerlevel10k
if [ -z "${DF_POWERLEVEL}" ]; then
   DF_POWERLEVEL="${HOME}/.dotfiles/powerlevel10k/powerlevel10k.zsh-theme"
fi
if [ ! -z "${DF_POWERLEVEL}" ] && [ -e "${DF_POWERLEVEL}" ]; then
  . ${DF_POWERLEVEL}
  DF_POWERLEVEL_CONFIG="${HOME}/.p10k.zsh"
  if [ ! -e ${DF_POWERLEVEL_CONFIG} ]; then
     echo "Missing p10k config: ${DF_POWERLEVEL_CONFIG}"
  else
     . ${DF_POWERLEVEL_CONFIG}
  fi
fi

# HAS_PYTHON3=$(if [ -z "$(env python3 --version 2>/dev/null)" ]; then echo "0"; else echo "1"; fi)
# if [ "${HAS_PYTHON3}" != "1" ]; then
#    echo "No python3 found, running in compat mode.."
# fi # end of python block

typeset -aU path
typeset -TaU LD_LIBRARY_PATH ld_library_path

# fzf support
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
else
  # we are in vi mode, so re-enable ctr-r history search
  bindkey '^R' history-incremental-search-backward
fi
