#################
# Aliases
#################
alias time='/usr/bin/time'
alias open='xdg-open'
alias ls='ls --color=auto'
alias lr='ls -latrh'
alias lt='ls -tr'
alias bc='bc -l'
alias less='less -S'
alias glances='glances --theme-white'
alias ..='cd ..'
alias make='make -j -l 1'
alias g='git'

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
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh

#################
# Autocomplete
#################

# Autocomplete Hostnames for SSH etc.
# by Jean-Sebastien Morisset (http://surniaulula.com/)
_complete_hosts () {
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    host_list=`{
        for c in /etc/ssh_config /etc/ssh/ssh_config ~/.ssh/config
        do [ -r $c ] && sed -n -e 's/^Host[[:space:]]//p' -e 's/^[[:space:]]*HostName[[:space:]]//p' $c
        done
        for k in /etc/ssh_known_hosts /etc/ssh/ssh_known_hosts ~/.ssh/known_hosts
        do [ -r $k ] && egrep -v '^[#\[]' $k|cut -f 1 -d ' '|sed -e 's/[,:].*//g'
        done
        sed -n -e 's/^[0-9][0-9\.]*//p' /etc/hosts; }|tr ' ' '\n'|grep -v '*'`
    COMPREPLY=( $(compgen -W "${host_list}" -- $cur))
    return 0
}
complete -F _complete_hosts ssh
complete -F _complete_hosts host
complete -F _complete_hosts ping
complete -F _complete_hosts vncviewer

# powerline support
if [ -e ~/.powerline ];
then
  POWERLINE_BASE=$(readlink -f ~/.powerline)
  BASH_POWERLINE=~/.powerline.sh
  if [ ! -e ${BASH_POWERLINE}  ]; then
    BASH_POWERLINE=${POWERLINE_BASE}/bindings/bash/powerline.sh
  fi
fi
if [ -e ${BASH_POWERLINE} ]; then
  export PATH="${PATH}:${POWERLINE_BASE}/../../../../bin"
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . ${BASH_POWERLINE}
else
  # no powerline support for bash
  export PS1="\[$(ppwd)\]\u@\h:\w>"
fi
