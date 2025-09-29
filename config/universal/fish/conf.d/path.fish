if test (uname) = Darwin
    # Load Homebrew binaries
    add_path /opt/homebrew/bin
end

# Load local binaries
if test -d "~/.local/bin"
    if not contains -- "~/.local/bin" $PATH
        add_path "~/.local/bin"
    end
end

# Load Go binaries
add_path "$HOME/go/bin"

# Load Composer tools
add_path "$HOME/.composer/vendor/bin"

# Load Node global installed binaries
add_path "$HOME/.node/bin"

# Use project-specific binaries before global ones
add_path "node_modules/.bin"
add_path vendor/bin

# Load bun into path
add_path "$HOME/.bun/bin"

# Added by LM Studio CLI (lms)
add_path "$HOME/.cache/lm-studio/bin"

# Use Homebrew version of Ruby over macOS version
if test -d /opt/homebrew/opt/ruby/bin
    add_path /opt/homebrew/opt/ruby/bin
    add_path (gem environment gemdir)/bin
end
