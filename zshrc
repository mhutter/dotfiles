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

bindkey -s '^F' '^Usource <(oc completion zsh)\n'

# load some initialization which is common for all shells
[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"

# load work-specifics
find "$HOME" -maxdepth 1 -name '.*-vshn' |
while read -r file; do
  source "$file"
done

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
  "${HOME}/src/google-cloud-sdk/completion.zsh.inc"
  "${HOME}/src/google-cloud-sdk/path.zsh.inc"
  /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
  /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
)
for p in "${plugins[@]}"; do
  test -f "$p" && source "$p"
done
:

# added by travis gem
[ -f /Users/mhutter/.travis/travis.sh ] && source /Users/mhutter/.travis/travis.sh

[ -f /usr/local/bin/mc ] && {
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/local/bin/mc mc
}
