# Plugin Config
function zvm_before_init_opts() {
    ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
    # Use insert mode by default
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    # jk to switch to command mode
    ZVM_VI_ESCAPE_BINDKEY=jk
    # Switching between Insert and Normal mode have less timeout but not too low so that jk works
    ZVM_KEYTIMEOUT=0.1

    # Change highlight colors
    ZVM_VI_HIGHLIGHT_BACKGROUND=#3e4452
    ZVM_VI_HIGHLIGHT_FOREGROUND=#abb3be
}
function zvm_after_init() {
  bindkey '^ ' autosuggest-accept
}

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt" 
zvm_before_init_opts; plug "zsh-users/zsh-syntax-highlighting" # Load and initialise completion system
plug "jeffreytse/zsh-vi-mode" # Vi mode
autoload -Uz compinit
compinit

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/arhan/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/arhan/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

eval "$(starship init zsh)"
alias omni_python='~/.local/share/ov/pkg/isaac-sim-2023.1.1/python.sh'


# paths
export PATH=/usr/local/cuda-11.8/bin/:$PATH
export PATH=~/projects/OpenUSD/build/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$PATH

alias vim=nvim
alias ls="ls -lha --color=auto"
alias s="kitten ssh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

