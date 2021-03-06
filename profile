# vim: ft=sh
[ -z "$__PROFILE" ] || return
export __PROFILE=loaded

export EDITOR=vim
export FLUX_FORWARD_NAMESPACE=flux
export LANG=en_US.UTF-8
export LANGUAGE=$LANG
export LC_ALL=$LANG
export LC_CTYPE=$LANG
export LESS='-R -F -X'
export NVM_DIR="$HOME/.nvm"
export PATH="${HOME}/bin:${PATH}"

# load local env vars
# shellcheck source=/dev/null
[ -f "${HOME}/.env" ] && source "${HOME}/.env"

# various PATH locations
paths=(
  "${HOME}/.yarn/bin"
  "${HOME}/.cargo/bin"
)
for p in "${paths[@]}"; do
  test -d "$p" && PATH="${p}:${PATH}"
done
export PATH

which go &>/dev/null && \
  PATH="$(go env GOPATH)/bin:${PATH}" && \
  export PATH

which rustup &>/dev/null && \
  RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src" && \
  export RUST_SRC_PATH

# various sources
[ -d "/usr/local/opt/libxml2/lib/pkgconfig" ] && \
  export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"
