export ZSH="/home/uint/.oh-my-zsh"

ZSH_THEME="mortalscumbag"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

source $HOME/.cargo/env

alias mk='make -j'
alias grep='grep --color=always'
alias -g L='|less -R'
alias -g WF='`fzf`'
alias df='df -h'
alias vi='vim'
alias time='/usr/bin/time -p '
alias mc="make clean"
alias sl="ls"
alias vim="nvim"
alias kat='curl -s https://thiscatdoesnotexist.com/ --output - -q>/tmp/cat.png && viu -h 20 /tmp/cat.png'
alias pbcopy='xsel --clipboard --input'
alias bigfiles='du -a ./ | sort -n -r | head -n100 | less'

export PATH=${PATH}:/opt/riscv/bin
export PATH=${PATH}:/usr/local
export PATH=${PATH}:/home/uint/.local/bin

tmpspace() {
  (
  d=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX") && cd "$d" || exit 1
  "$SHELL")
}

viewonnx() {
  onnx=${1?Missing ONNX file path.}

  if [ ! -f "${onnx}" ]; then
    printf "File not foud: \e[1m${onnx}\x1B[0m\n"
    return
  fi

  if [ ! -e $HOME/onnx2html.py ]; then
    curl https://raw.githubusercontent.com/shinh/test/master/onnx2html.py > $HOME/onnx2html.py
  fi

  tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/onnx2html.XXXXXXXXXX")

  python3 $HOME/onnx2html.py "${onnx}" "${tmpdir}/onnx.html"

  if [ -x "$(command -v w3m)" ]; then
    w3m "${tmpdir}/onnx.html"
  fi

  printf "Generated html at \e[4m\e[1m${tmpdir}/onnx.html\x1B[0m\n"
}

export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$PATH:/usr/local/go/bin

# TODO 
export PATH="$HOME/.poetry/bin:$PATH"
source $HOME/.poetry/env

# TODO
# . /home/uint/torch/install/bin/torch-activate

export PATH=${PATH}:/home/uint/work/zig/build/bin/
export PATH=${PATH}:/home/uint/go/bin/

# TODO
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export PATH="$PATH:${HOME}/work/depot_tools"
export PATH="$PATH:${HOME}/work/arcanist/bin/"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH="/usr/local/cuda-11.4/bin/:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-11.4/lib64/:$LD_LIBRARY_PATH"

export GPG_TTY=$(tty)
