apt-get update
apt-get upgrade

# required softwares
apt-get install vim git zsh
git clone http://github.com/maekawatoshiki/dotfiles ~/.dotfiles

# vim
ln -sf ~/.dotfiles/vimrc ~/.vimrc
ln -sf ~/.dotfiles/vim ~/.vim
ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -sf ~/.dotfiles/zshrc ~/.zshrc
