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
plugins=(git docker mix)
source "${ZSH}/oh-my-zsh.sh"

# Code and Projects
c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

p() { cd ~/Projects/$1; }
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
