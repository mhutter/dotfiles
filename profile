# vim: ft=sh
[ -z "$__PROFILE" ] || return
export __PROFILE=loaded

export EDITOR=nvim
export PATH="${HOME}/bin:${PATH}"
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export LC_CTYPE=$LANG
export NVM_DIR="$HOME/.nvm"

# load local env vars
[ -f "${HOME}/.env" ] && source "${HOME}/.env"

# various PATH locations
paths=(
  "${HOME}/.yarn/bin"
  /usr/local/opt/python/libexec/bin
  "${HOME}/.cargo/bin"
  "${HOME}/.gem/ruby/2.3.0/bin"
)
for p in $paths; do
  test -d "$p" && PATH="${p}:${PATH}"
done
export PATH

which rustup &>/dev/null && \
  RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src" && \
  export RUST_SRC_PATH

# various sources
