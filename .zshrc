if [ -z "${SOURCED_DOT_PROFILE}" ]; then
   source ~/.profile
fi


# low level version compare, used to check if we skip most of this for old zshs
# returns whether the first arg is a larger or equal compared to second version
# relies on sort -V
larger_version() {
   echo "
${1}
${2}
" | sort -V | tail -1
}

if [ "$(larger_version ${ZSH_VERSION} 5)" = "5" ]
then
   export PS1='%F%B%n%f@%m %F%~: %f%b'
   echo "Old zsh detected, using fallback config!"
   return
fi

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' menu select

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
setopt interactivecomments
bindkey -e

# End of lines configured by zsh-newuser-install

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
alias bc='bc -l'
alias g='git'
alias glances='glances --theme-white'
alias less='less -S'
alias lr='ls -latrh'
alias ls='ls --color=auto'
alias lt='ls -tr'
alias open='xdg-open'
alias time='/usr/bin/time'
alias nv='nvim'
alias vim='echo "Use nvim!"'

#################
# Functions
#################

cw() {
   cmd=$1
   cat `which ${cmd}`
}

vw() {
   cmd=$1
   vim `which ${cmd}`
}

rlf() { readlink -f ${@}; }

pushj() { pushd .; j $@; }
popj() { popd; }

################
# Tools
################

# dircolors
eval `dircolors ~/.dir_colors`

# autojump support
if [ -z "${DF_AUTOJUMP}" ] && [ -e ~/.autojump-shell-base ]; then
  DF_AUTOJUMP=~/.autojump-shell-base
  ZSH_AUTOJUMP=${DF_AUTOJUMP}/autojump.zsh
fi
if [ ! -z "${ZSH_AUTOJUMP}" ] && [ -e "${ZSH_AUTOJUMP}" ]; then
  . ${ZSH_AUTOJUMP}
fi

# powerline support
if [ -z "${DF_POWERLINE}" ] && [ -e ~/.powerline ]; then
  DF_POWERLINE=~/.powerline
fi
if [ -z "${DF_POWERLINE_ZSH}" ] && [ -e ~/.powerline.zsh ]; then
  DF_POWERLINE_ZSH=~/.powerline.zsh
fi
if [ ! -z "${DF_POWERLINE}" ] && [ -e "${DF_POWERLINE}" ]; then
  if [ ! -z "${DF_POWERLINE_ZSH}" ]; then
    ZSH_POWERLINE=${DF_POWERLINE_ZSH}
  else
    ZSH_POWERLINE=${DF_POWERLINE}/bindings/zsh/powerline.zsh
  fi
fi
if [ ! -z "${ZSH_POWERLINE}" ] && [ -e ${ZSH_POWERLINE} ]; then
  export PATH="${PATH}:${DF_POWERLINE}/../../../../bin"
  powerline-daemon -q
  POWERLINE_ZSH_CONTINUATION=1
  POWERLINE_ZSH_SELECT=1
  . ${ZSH_POWERLINE}
else
  # no powerline support for .zsh
  #export PS1="\u@\h:\w: "
fi

# de-dup PATH. Note: OrderedDict preserves input order.
PATH=$(python3 -c 'import os; from collections import OrderedDict; \
    l=os.environ["PATH"].split(":"); print(":".join(OrderedDict.fromkeys(l)))' )
