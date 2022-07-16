#!/bin/bash

ZSH_PLUGINS_PATH="$HOME/.zsh-plugins"
TEMPORARY_CLONE_PATH="/tmp"
ZSHRC="$HOME/.zshrc"

# atualizar o sistema
sudo pacman -Syyuu --noconfirm

# lunarvim
sudo pacman -S neovim git yarn npm rust base-devel --noconfirm
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
echo 'export PATH=$HOME/.cargo/bin:$HOME/.local.bin:$PATH' >> $HOME/.bashrc # mover para o final
echo 'export PATH=$HOME/.cargo/bin:$HOME/.local.bin:$PATH' >> $ZSHRC # mover para o final

# yay 
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd /tmp/yay
makepkg -si --noconfirm
yay -Syyuu --noconfirm

#zsh
yay -S zsh zsh-theme-powerlevel10k-git ttf-meslo-nerd-font-powerlevel10k powerline-fonts awesome-terminal-fonts --noconfirm
echo "source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" >> $ZSHRC
mkdir -p $ZSH_PLUGINS_PATH
git clone https://github.com/z-shell/F-Sy-H $ZSH_PLUGINS_PATH/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGINS_PATH/zsh-autosuggestions
echo "source $ZSH_PLUGINS_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $ZSHRC
echo "source $ZSH_PLUGINS_PATH/fast-syntax-highlighting/F-Sy-H.plugin.zsh" >> $ZSHRC

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
# echo "zinit light zdharma/fast-syntax-highlighting" >> $HOME/.zshrc 
# echo "zinit light zsh-users/zsh-autosuggestions" >> $HOME/.zshrc 
# echo "zinit light zsh-users/zsh-completions" >> $HOME/.zshrc 
chsh -s $(which zsh)

# chrome
yay -S google-chrome --noconfirm

# flatpak
yay -S flatpak --noconfirm
