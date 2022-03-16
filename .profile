if [ ! -z "${SOURCED_DOT_PROFILE}" ]; then
  return
fi
SOURCED_DOT_PROFILE=1

export EDITOR="nvim -u NONE"
export VISUAL=${EDITOR}
export LANG=en_US.UTF-8
export GREP_COLORS=""
export LD_LIBRARY_PATH="${HOME}/software/lib64:${LD_LIBRARY_PATH}"
export MAKEFLAGS="-j$(nproc)"
export BROWSER=/usr/bin/google-chrome-stable
export TERMINAL=/usr/bin/konsole

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
prepend_to_path_if_exists "${HOME}/.local/bin"
prepend_to_path_if_exists "${HOME}/software/bin"
#prepend_to_path_if_exists "${HOME}/software/texlive/2019/bin/x86_64-linux"
prepend_to_path_if_exists "${HOME}/go/bin"

# Only run this locally
if [ -z "${SSH_CONNECTION}" ]; then
   setxkbmap -option caps:escape
fi

source_if_exists "${HOME}/.profile.local"
