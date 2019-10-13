# Load Composer tools
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Load Node pnpm global installed binaries
export PATH="/usr/local/Cellar/node/12.11.1/pnpm-global/2/node_modules:$PATH"

# Use project specific binaries before global ones
export PATH="node_modules/.bin:vendor/bin:$PATH"

# Local bin directories before anything else
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
