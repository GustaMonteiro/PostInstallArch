#!/usr/bin/env bash

for i in "$@"
do
    case $i in
        --clone)
            CLONE=true
            shift
            ;;
        --minimal)
            MINIMAL=true
            shift
            ;;
        *)
            echo "Unknown option: $i"
            exit 1
            shift
            ;;
    esac
done

ZSH_PLUGINS_PATH="$HOME/.zsh-plugins"
MY_PROJECTS_PATH="$HOME/workspace/my-projects"
TEMPORARY_CLONE_PATH="/tmp"
ZSHRC="$HOME/.zshrc"

LISTA_PROGRAMAS_MINIMAL=(
  google-chrome
  neovim
  yarn
  npm
  rust
  zsh
  zsh-theme-powerlevel10k-git
  ttf-meslo-nerd-font-powerlevel10k
  powerline-fonts
  awesome-terminal-fonts
  visual-studio-code-bin
  xclip
  ctags
  tree
)

LISTA_PROGRAMAS_OPTIONAL=(
  spotify
  sublime-text
  texlive-most
  texmaker
  geogebra
  flatpak
  discord
  zoom
  vlc
  gimp
  obs-studio
  notion-app
  kdenlive
  breeze
  youtube-dl
  speedtest-cli
  onlyoffice-bin
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

instalar_pacotes_minimal () {
  yay -S ${LISTA_PROGRAMAS_MINIMAL[@]} --noconfirm
}

instalar_pacotes_optional () {
  yay -S ${LISTA_PROGRAMAS_OPTIONAL[@]} --noconfirm
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

# Ensure that base-devel is installed
sudo pacman -S base-devel git --noconfirm --needed

instalar_yay
instalar_pacotes_minimal

if [ -z "$MINIMAL" ]; then
  instalar_pacotes_optional
fi

instalar_lunarvim
instalar_zsh
exports_e_sources
instalar_pacotes_cargo

if [ "$CLONE" ]; then
    mkdir -p $MY_PROJECTS_PATH
    git clone https://github.com/GustaMonteiro/PostInstallArch.git $MY_PROJECTS_PATH/PostInstallArch
fi

chsh -s $(which zsh)
