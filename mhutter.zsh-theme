# elaborate exitcode when >0
return_code_enabled="%(?..%{$fg[red]%}-%?- %{$reset_color%})"
return_code_disabled=
local return_code=$return_code_enabled

# Theming for the oh-my-zsh git helper
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✓"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"

PROMPT='${return_code}%{$fg[blue]%}%* %{$fg[green]%}%1d%b%{$reset_color%}$(git_prompt_info) %{$fg[yellow]%}$ %{$reset_color%}'
