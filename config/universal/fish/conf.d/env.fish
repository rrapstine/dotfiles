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

# Eza colors for catppuccin-mocha with mauve accent
set -q EZA_COLORS; or set -Ux EZA_COLORS "reset:di=1;38;2;198;160;246:ln=1;38;2;249;226;175:so=38;2;243;139;168:pi=38;2;243;139;168:ex=1;38;2;166;227;161:bd=38;2;180;190;254:cd=38;2;180;190;254:su=38;2;205;214;244:sg=38;2;205;214;244:tw=38;2;205;214;244:ow=38;2;205;214;244"
