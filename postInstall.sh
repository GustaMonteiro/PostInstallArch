#!/usr/bin/env bash

for i in "$@"
do
    case $i in
        # --clone)
        #     CLONE=true
        #     shift
        #     ;;
        --minimal)
            MINIMAL=true
            shift
            ;;
        *)
            echo "Opcao desconhecida: $i"
            exit 1
            shift
            ;;
    esac
done

ZSH_PLUGINS_PATH="$HOME/.zsh-plugins"
MY_PROJECTS_PATH="$HOME/workspace/my-projects"
TEMPORARY_CLONE_PATH="/tmp"
ZSHRC="$HOME/.zshrc"

LISTA_PROGRAMAS_MINIMAL_PACMAN=(
  neovim
  yarn
  npm
  rust
  zsh
  powerline-fonts
  awesome-terminal-fonts
  xclip
  ctags
  tree
  kitty
)

LISTA_PROGRAMAS_MINIMAL_AUR=(
  google-chrome
  zsh-theme-powerlevel10k-git
  ttf-meslo-nerd-font-powerlevel10k
  visual-studio-code-bin
)

LISTA_PROGRAMAS_OPCIONAL_PACMAN=(
  texlive-most
  texmaker
  geogebra
  flatpak
  discord
  vlc
  gimp
  obs-studio
  kdenlive
  breeze
  youtube-dl
  speedtest-cli
)

LISTA_PROGRAMAS_OPCIONAL_AUR=(
  spotify
  zoom
  notion-app
  onlyoffice-bin
  sublime-text-4
)

LISTA_PACOTES_CARGO=(
  exa
  git-delta
  bat
)

atualizar_tudo () {
  sudo pacman -Syyuu --noconfirm --needed
}

instalar_yay () {
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd /tmp/yay
  makepkg -si --noconfirm
  yay -Syyuu --noconfirm
  cd
}

instalar_pacotes_minimal () {
  sudo pacman -S ${LISTA_PROGRAMAS_MINIMAL_PACMAN[@]} --noconfirm
  yay -S ${LISTA_PROGRAMAS_MINIMAL_AUR[@]} --noconfirm
}

instalar_pacotes_opcional () {
  sudo pacman -S ${LISTA_PROGRAMAS_OPCIONAL_PACMAN[@]} --noconfirm
  yay -S ${LISTA_PROGRAMAS_OPCIONAL_AUR[@]} --noconfirm
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

# Inicio das funcoes

atualizar_tudo

# Garantir que o necessario para o yay esteja instalado
sudo pacman -S base-devel git --noconfirm --needed

instalar_yay
instalar_pacotes_minimal

if [ -z "$MINIMAL" ]; then
  instalar_pacotes_opcional
fi

instalar_lunarvim
instalar_zsh
exports_e_sources

if [ -z "$MINIMAL" ]; then
  instalar_pacotes_cargo
fi

# if [ "$CLONE" ]; then
#     mkdir -p $MY_PROJECTS_PATH
#     git clone https://github.com/GustaMonteiro/PostInstallArch.git $MY_PROJECTS_PATH/PostInstallArch
# fi

cp gitconfig $HOME/.gitconfig

chsh -s $(which zsh)
