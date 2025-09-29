# Replace ls with eza
abbr -a ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
abbr -a la 'eza -a --color=always --group-directories-first --icons' # all files and dirs
abbr -a ll 'eza -l --color=always --group-directories-first --icons' # long format
abbr -a lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
abbr -a l. 'eza -a | grep -e "^\."' # show only dotfiles

# General QoL
abbr -a .. 'cd ..'
abbr -a nuke 'rm -rf'
abbr -a clear 'clear && ls'

# Git shortcuts
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gaa 'git add -A'
abbr -a gc 'git commit -m'
abbr -a gca 'git commit -am'
abbr -a gra 'git remote add'
abbr -a gco 'git checkout'
abbr -a gpush 'git push'
abbr -a gpull 'git pull'
abbr -a gpo 'git push origin'
abbr -a gnah 'git reset --hard && git clean -df'

# Application shortcuts
abbr -a lazy lazygit
abbr -a vim nvim
abbr -a zj zellij

# CachyOS
abbr -a mirror 'sudo cachyos-rate-mirrors'
