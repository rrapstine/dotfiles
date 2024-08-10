# Export Host UID
export HOST_UID=$(id -u)

# Manually set the language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Enable zsh completions
fpath=(~/.zsh_completions $fpath)
autoload -Uz compinit && compinit -u

# Enable zoxide
eval "$(zoxide init zsh)"

# Path to dotfiles installation
export DOTFILES=$HOME/.dotfiles

# Path to warp config folder
export WARP=$HOME/.warp

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$DOTFILES

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Source aliases file
source $DOTFILES/aliases.zsh

# Source functions file
source $DOTFILES/functions.zsh

# Source path file
source $DOTFILES/path.zsh

# Setup for nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# Setup for pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/richard/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/richard/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/richard/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/richard/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/richard/.bun/_bun" ] && source "/Users/richard/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

PATH=~/.console-ninja/.bin:$PATH