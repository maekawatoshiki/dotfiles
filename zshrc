# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="mortalscumbag"

plugins=(git zsh-autosuggestions)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888,underline"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh

source $HOME/.cargo/env

alias n='ninja'
alias t='tmux'
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
export PATH=${PATH}:/usr/local/bin
export PATH=${PATH}:$HOME/.local/bin

tmpspace() {
  (
  d=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX") && cd "$d" || exit 1
  "$SHELL")
}

tmpsp() {
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

export PATH=$PATH:/usr/local/go/bin

# TODO
# . $HOME/torch/install/bin/torch-activate

export PATH=${PATH}:$HOME/work/zig/build/bin/

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
export PATH=${PATH}:$HOME/go/bin/ # TODO: Is this necessary?
eval "$(goenv init -)"

export PATH="$PATH:${HOME}/work/depot_tools"
export PATH="$PATH:${HOME}/work/arcanist/bin/"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

export PATH="/usr/local/cuda/bin/:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64/:$LD_LIBRARY_PATH"

export GPG_TTY=$(tty)

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
eval "$(nodenv init - zsh)"
