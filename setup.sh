#!/bin/zsh

cd "$(dirname "$0")" || exit 1
dir=$(pwd)

#
# Install and set up Oh My Zsh
#
OH_MY_ZSH="${HOME}/.oh-my-zsh"
if [ ! -e "${OH_MY_ZSH}" ]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git "$OH_MY_ZSH"
fi
mkdir -p "${OH_MY_ZSH}/custom/themes"
ln -sf "${dir}/*.zsh-theme" "${OH_MY_ZSH}/custom/themes"

#
# Link common dotfiles
#

# List of files to skip when linking
skipfiles=($(basename "$0") *.zsh-theme)

find . -maxdepth 1 -type f -exec basename "{}" \; |
while read -r file; do
  if [[ ${skipfiles[(r)$file]} != "$file" ]]; then
    ln -sf "${dir}/${file}" "${HOME}/.${file}"
  fi
done

#
# Link .config dirs
#
ls -1 config/ |
while read -r cdir; do
  target="${HOME}/.config/${cdir}"
  if [ ! -L "$target" ]; then
    rm -r "$target"
    ln -sf "${dir}/config/${cdir}" "$target"
  fi
done
