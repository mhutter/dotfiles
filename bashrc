# On some OSes (eg. macOS) .profile is not loaded by default so load it by
# default. It has a mechanism in place which avoids loading it twice.
[ -f "${HOME}/.profile" ] && source "${HOME}/.profile"

# nothing to see here - I mostly use ZSH these days...
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

if [ -z "$NVIM_LISTEN_ADDRESS" ]; then
  which oc &>/dev/null && source <(oc completion bash)
  which kubectl &>/dev/null && source <(kubectl completion bash)
fi

[ -f "${HOME}/.commonrc" ] && source "${HOME}/.commonrc"
