#!/bin/bash

ZSH_PLUGINS_PATH="$HOME/.zsh-plugins"
TEMPORARY_CLONE_PATH="/tmp"
ZSHRC="$HOME/.zshrc"

LISTA_PROGRAMAS=(
  google-chrome
  spotify
  sublime-text
  texlive-most
  texmaker
  geogebra
  flatpak
  neovim
  git
  yarn
  npm
  rust
  base-devel
  zsh
  zsh-theme-powerlevel10k-git
  ttf-meslo-nerd-font-powerlevel10k
  powerline-fonts
  awesome-terminal-fonts
  discord
  zoom
  vlc
  gimp
  visual-studio-code-bin
  obs-studio
)

LISTA_PACOTES_CARGO=(
  exa
  git-delta
  bat
)

instalar_yay () {
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd /tmp/yay
  makepkg -si --noconfirm
  yay -Syyuu --noconfirm
  cd
}

instalar_pacotes () {
  yay -S ${LISTA_PROGRAMAS[@]} --noconfirm
}

instalar_lunarvim () {
  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
}

instalar_zsh () {
  mkdir -p $ZSH_PLUGINS_PATH
  git clone https://github.com/z-shell/F-Sy-H $ZSH_PLUGINS_PATH/fast-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS_PATH/zsh-autosuggestions
}

exports_e_sources () {
  echo 'export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH' >> $ZSHRC 
  echo "source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" >> $ZSHRC
  echo "source $ZSH_PLUGINS_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $ZSHRC
  echo "source $ZSH_PLUGINS_PATH/fast-syntax-highlighting/F-Sy-H.plugin.zsh" >> $ZSHRC
}

instalar_pacotes_cargo () {
  cargo install ${LISTA_PACOTES_CARGO[@]} 
}

instalar_yay
instalar_pacotes
instalar_lunarvim
instalar_zsh
exports_e_sources
instalar_pacotes_cargo

chsh -s $(which zsh)
