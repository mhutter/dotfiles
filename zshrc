# shellcheck source=/dev/null
# On some OSes (eg. macOS) .profile is not loaded by default so load it by
# default. It has a mechanism in place which avoids loading it twice.
[ -f "${HOME}/.profile" ] && source "${HOME}/.profile"

#
# Set up Oh My Zsh
#
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="mhutter"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
plugins=(git docker)
source "${ZSH}/oh-my-zsh.sh"

# Open new gnome-terminal windows with the same working dir
if [ -d /dev/shm ]; then
  cd $(<>/dev/shm/${USER}-pwd)
  __cd() {
    \cd "$@"
    pwd >/dev/shm/${USER}-pwd
  }
  alias cd=__cd
fi

# Code and Projects
c() { cd "${HOME}/code/$1" || return 1; }
_c() { _files -W ~/code -/; }
compdef _c c

p() { cd "${HOME}/Projects/$1" || return 1; }
_p() { _files -W ~/Projects -/; }
compdef _p p

dev() { cd "${HOME}/Developer/$1" || return 1; }
_dev() { _files -W ~/Developer -/; }
compdef _dev dev

bindkey -s '^F' '^Usource <(oc completion zsh)\n'

# load some initialization which is common for all shells
[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"

# load work-specifics
[ -f "${HOME}/.zshrc-vshn" ] && source "${HOME}/.zshrc-vshn"

# Cleanup env vars and make sure rc-files are reloaded in tmux
for v in $(env | grep '^__.*=loaded$' | cut -d= -f1); do
  unset "$v"
done

which hcloud &>/dev/null && source <(hcloud completion zsh)

plugins=(
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
)
for p in "${plugins[@]}"; do
  test -f "$p" && source "$p"
done
:

# SSH completion
function buildSSHCompletion() {
  h=()
  if [[ -r ~/.ssh/sshop_config ]]; then
    h=($h ${(s. .)${${(@M)${(f)"$(cat ~/.ssh/sshop_config)"}:#Host *}#Host }:#*[*?]*})
  fi
  if [[ -r ~/.ssh/config ]]; then
    h=($h ${(s. .)${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
  fi
  if [[ $#h -gt 0 ]]; then
    zstyle ':completion:*:ssh:*' hosts $h
    zstyle ':completion:*:slogin:*' hosts $h
    zstyle ':completion:*:scp:*' hosts $h
  fi
}

buildSSHCompletion

[ -f /usr/local/bin/mc ] && {
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/local/bin/mc mc
}
