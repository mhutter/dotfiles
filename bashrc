# On some OSes (eg. macOS) .profile is not loaded by default so load it by
# default. It has a mechanism in place which avoids loading it twice.
[ -f "${HOME}/.profile" ] && source "${HOME}/.profile"

# load liquidprompt
if [ -f ~/.liquidprompt/liquidprompt ]; then
  [[ $- = *i* ]] && source ~/.liquidprompt/liquidprompt
fi


if [ -z "$NVIM_LISTEN_ADDRESS" ]; then
  function p() { cd ~/Projects/$1; }
  function c() { cd ~/code/$1; }
  function da() { cd ~/Projects/vshn_puppet/data/$1; }
  [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
  which oc &>/dev/null && source <(oc completion bash)
fi

_p() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  cd ~/Projects && _filedir
}
complete -F _p p

_c() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  cd ~/code && _filedir
}
complete -F _c c

_da() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  cd ~/Projects/vshn_puppet/data && _filedir
}
complete -F _da da

[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"
