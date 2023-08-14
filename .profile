if [ ! -z "${SOURCED_DOT_PROFILE}" ]; then
  return
fi
SOURCED_DOT_PROFILE=1

export EDITOR="nvim -u NONE"
export VISUAL=${EDITOR}
export LANG=en_US.UTF-8
export GREP_COLORS=""
export LD_LIBRARY_PATH="${HOME}/software/lib64:${LD_LIBRARY_PATH}"
export BROWSER=/usr/bin/google-chrome-stable
export TERMINAL=/usr/bin/konsole
export P4CONFIG=".p4config"

# Set cache dir. Some tools (e.g. ccache) use this to default
# their cache directory. We set it here to ensure it is used,
# because it is on a separate BTRFS subvolume.
export XDG_CACHE_HOME="${HOME}/.cache"

prepend_to_path_if_exists() {
   ARG=${1}
   if [ -e "${ARG}" ]
   then
      PATH="${ARG}:${PATH}"
   fi
}

source_if_exists() {
   if [ -e "${1}" ]
   then
      . "${1}"
   fi
}

prepend_to_path_if_exists "${HOME}/.cargo/bin"
prepend_to_path_if_exists "${HOME}/bin"
prepend_to_path_if_exists "${HOME}/scripts"
prepend_to_path_if_exists "${HOME}/.local/bin"
prepend_to_path_if_exists "${HOME}/software/bin"
#prepend_to_path_if_exists "${HOME}/software/texlive/2019/bin/x86_64-linux"
prepend_to_path_if_exists "${HOME}/go/bin"
prepend_to_path_if_exists "${HOME}/software/llvm/16.0.4/bin"

# Only run this locally
if [ -z "${SSH_CONNECTION}" ]; then
   setxkbmap -option caps:escape
fi

source_if_exists "${HOME}/.profile.local"

update_dot_profile() {
   unset SOURCED_DOT_PROFILE
   source ~/.profile
}
