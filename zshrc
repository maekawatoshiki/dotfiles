export ZSH=~/.oh-my-zsh

ZSH_THEME="dallas"

plugins=(git)

source $ZSH/oh-my-zsh.sh


alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias install='sudo apt-get install'
alias mk='make -j'

# alias grep='grep -nE --color=always'
alias -g L='|less'
alias df='df -h'
alias vi='vim'
alias time='/usr/bin/time -p '
alias mc="make clean"
alias sl="ls"

alias trans='gawk -f ~/.trans.awk'
export PATH="$HOME/local/bin:$PATH"

PATH="/home/unsigned/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/unsigned/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/unsigned/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/unsigned/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/unsigned/perl5"; export PERL_MM_OPT;
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export CXX="/usr/bin/clang++-3.8"
source ~/.cargo/env
export LD_LIBRARY_PATH=$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib:$LD_LIBRARY_PATH
alias baba='curl -s http://baba.mdja.jp/ | iconv -f Shift-JIS -t UTF-8 | grep -oE "<span class=\"red\">.{1,10}</span" | grep -oE "[0-9]+" '

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

alias lock='sudo pm-suspend; xtrlock -b'

# added by Anaconda3 installer
export PATH="/home/unsigned/anaconda3/bin:$PATH"

tmpspace() {
  (
  d=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX") && cd "$d" || exit 1
  "$SHELL"
}

rustkcov() {
  DIRNAME=${PWD##*/}
  REPORT=$(find ./target/debug -maxdepth 1 -name "$DIRNAME-*" -a ! -name '*.d')
  echo $REPORT | while read file; do
  # for file in $REPORT; do  
    echo $file
    /usr/local/bin/kcov --include-pattern=$DIRNAME/src --exclude-pattern=/.cargo ./target/cov "$file"
  done
}
