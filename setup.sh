#!/usr/bin/env zsh

cd "$(dirname "$0")" || exit 1
dir=$(pwd)

#
# Install and set up Oh My Zsh
#
OH_MY_ZSH="${HOME}/.oh-my-zsh"
if [ ! -e "${OH_MY_ZSH}" ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git "$OH_MY_ZSH"
else
  pushd "$OH_MY_ZSH" || exit 1
  git pull --prune
  popd || exit 1
fi
mkdir -p "${OH_MY_ZSH}/custom/themes"
ln -sf "$dir"/*.zsh-theme "${OH_MY_ZSH}/custom/themes"

#
# Link common dotfiles
#

# List of files to skip when linking
skipfiles=(
  "$(basename "$0")"
  *.zsh-theme
  msgFilterRules.dat
)

find . -depth 1 -type f -exec basename "{}" \; |
while read -r file; do
  if [[ ${skipfiles[(r)$file]} != "$file" ]]; then
    ln -sf "${dir}/${file}" "${HOME}/.${file}"
  fi
done

#
# Link .config dirs
#
config="${HOME}/.config"
mkdir -p "$config"
find ./config/ -depth 1 -exec basename "{}" \; |
while read -r cdir; do
  target="${config}/${cdir}"
  test -e "$target" && rm -r "$target"
  ln -sf "${dir}/config/${cdir}" "$target"
done
