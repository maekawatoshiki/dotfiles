sudo apt-get update
sudo apt-get upgrade

# required softwares
sudo apt-get install vim git zsh
git clone http://github.com/maekawatoshiki/dotfiles ~/.dotfiles

# vim
ln -sf ~/.dotfiles/vimrc ~/.vimrc
ln -sf ~/.dotfiles/vim ~/.vim

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -sf ~/.dotfiles/zshrc ~/.zshrc
