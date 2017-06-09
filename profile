[ -z "$__PROFILE" ] || return
export __PROFILE=loaded

# Editor setup
EDITOR=vim
if which nvim &>/dev/null; then
  EDITOR=nvim
  alias vim=nvim
  alias nvc='nvim ~/.config/nvim/init.vim'
fi
export EDITOR

export PATH="${HOME}/bin:${PATH}"

export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export LC_CTYPE=$LANG

# load local env vars
[ -f "${HOME}/.env" ] && source "${HOME}/.env"

# vim: ft=sh
