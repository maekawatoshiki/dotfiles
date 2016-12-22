sudo apt-get update
sudo apt-get upgrade

# required softwares
sudo apt-get install vim git zsh
git clone http://github.com/maekawatoshiki/dotfiles ~/.dotfiles

# vim
ln -sf ~/.dotfiles/vimrc ~/.vimrc
ln -sf ~/.dotfiles/vim ~/.vim

# zsh
ln -sf ~/.dotfiles/oh-my-zsh ~/.oh-my-zsh
ln -sf ~/.dotfiles/zshrc ~/.zshrc
