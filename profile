[ -z "$__PROFILE" ] || return
export __PROFILE=loaded

export EDITOR=nvim
export PATH="${HOME}/bin:${PATH}"
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export LC_CTYPE=$LANG

# load local env vars
[ -f "${HOME}/.env" ] && source "${HOME}/.env"

# various PATH locations
[ -d "${HOME}/.yarn/bin" ] && export PATH="${HOME}/.yarn/bin:${PATH}"
plibexec=/usr/local/opt/python/libexec/bin
[ -d "$plibexec" ] && export PATH="${plibexec}:$PATH"

# vim: ft=sh
