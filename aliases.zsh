# Copy Public SSH Key
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"

# List Directory Using Updated CoreUtils
alias ll="$(brew --prefix coreutils)/libexec/gnubin/ls -AhlFo --color --group-directories-first"

# Use eza in place of ls
alias ls="eza -x --git --group-directories-first"

# Use eza in place of ls -lha
alias lsa="eza -x -a --git --group-directories-first"

# Use eza in place of tree
alias tree="eza -TL 2"

# Prompt on Remove, Move and Copy
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -iv"

# Show Number of Files in Directory
alias numfiles="find * -maxdepth 0 -type d -exec sh -c \"echo -n {} ' ' ; ls -lR {} | wc -l\" \;"

# General QoL
alias ..="cd .."
alias nuke="rm -rf"

# List Directory on Clear
alias clear="clear && ls"

# The Fuck
eval $(thefuck --alias)

# Reload Sources
alias reload="source $DOTFILES/.zshrc && clear && ls"

# Edit dotfiles
alias zconfig="nvim $DOTFILES"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias work="cd $HOME/Code"

# Node Commands
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias nwatch="npm run watch"

# Python Commands
alias python=python3
# alias pip="/usr/local/bin/pip3"

# Node Packages
alias ngui="npx npm-gui"
alias readme-gen="npx readme-md-generator"

# Go Binaries
alias air="~/go/bin/air"

# Docker Commands
# alias dclean="docker rmi -f $(docker images -qf dangling=true)"

# Docker-Compose Commands
alias dcomp="docker-compose"
alias dcup="docker-compose up"
alias dcbuild="docker-compose up --build"
alias dcstop="docker-compose stop"
alias dcclean="docker-compose rm -f"

# Git Commands
alias gs="git status"
alias gl="git log"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit -m"
alias gra="git remote add"
alias gco="git checkout"
alias gpush="git push"
alias gpull="git pull"
alias gpom="git push origin main"
alias nah="git reset --hard && git clean -df"

# Laravel Commands
alias sail="[ -f sail ] && sh sail || sh vendor/bin/sail"
