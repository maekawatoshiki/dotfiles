export ZSH=~/.oh-my-zsh

ZSH_THEME="dallas"

plugins=(git)

source $ZSH/oh-my-zsh.sh


alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias install='sudo apt-get install'
alias mk='make -j'

# alias vim='/usr/local/bin/vim'

alias grep='grep -nE --color=always'
alias -g L='|less'
alias df='df -h'
alias vi='vim'
alias time='/usr/bin/time -p '
alias mc="make clean"

