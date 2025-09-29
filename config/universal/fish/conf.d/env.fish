# Export Host UID
set -q HOST_UID; or set -Ux HOST_UID (id -u)

# Manually set the language environment
set -q LC_ALL; or set -Ux LC_ALL en_US.UTF-8
set -q LANG; or set -Ux LANG en_US.UTF-8

# Editor
set -q EDITOR; or set -Ux EDITOR nvim

# Paths
set -q CONFIG; or set -Ux CONFIG "$HOME/.config"
set -q DOTFILES; or set -Ux DOTFILES "$HOME/Code/dotfiles"
set -q WEZTERM_CONFIG_DIR; or set -Ux WEZTERM_CONFIG_DIR "$HOME/.config/wezterm"
set -q BUN_INSTALL; or set -Ux BUN_INSTALL "$HOME/.bun"

# Theme
set -q FISH_THEME; or set -U FISH_THEME catppuccin_mocha
