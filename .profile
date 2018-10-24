if [ ! -z "${SOURCED_DOT_PROFILE}" ]; then
  return
fi
SOURCED_DOT_PROFILE=1

export EDITOR=/usr/bin/vim
export VISUAL=${EDITOR}
export LANG=en_US.UTF-8
export GREP_COLORS=""
export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
