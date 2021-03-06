# List Directory Using Updated CoreUtils
alias ll="$(brew --prefix coreutils)/libexec/gnubin/ls -ahlF --color --group-directories-first"

# Prompt on Remove, Move and Copy
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -iv"

# List Hidden Files
alias lsa="ls -lha"

# Show Number of Files in Directory
alias numfiles="find * -maxdepth 0 -type d -exec sh -c \"echo -n {} ' ' ; ls -lR {} | wc -l\" \;"

# General QoL
alias ..="cd .."

# List Directory on Clear
alias clear="clear && ls"

# Reload Sources
alias reload="source $HOME/.zshrc"

# Edit dotfiles
alias zconfig="code $DOTFILES"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias sites="cd $HOME/Sites"

# Program Commands
alias python="/usr/local/bin/python3"
alias pip="/usr/local/bin/pip3"

# Docker Commands
alias dclean="docker rmi -f $(docker images -qf dangling=true)"

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
alias gpom="git push origin master"
alias nah="git reset --hard && git clean -df"

# Vagrant Commands
alias vssh="vagrant ssh"
alias vstat="vagrant status"
alias vhalt="vagrant halt"
alias vup="vagrant up"
alias vrel="vagrant reload"
