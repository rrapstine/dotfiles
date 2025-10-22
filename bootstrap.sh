#!/bin/bash

# Dotfiles Bootstrap Script
# Usage: ./bootstrap.sh [directory]
# Example: ./bootstrap.sh ~/Projects/my-dotfiles

set -e

# Configuration
DOTFILES_REPO="https://github.com/rrapstine/dotfiles.git"
DOTFILES_DIR="${1:-$HOME/Code/dotfiles}"
DOTFILES_BIN="$DOTFILES_DIR/bin/dotfiles"
USER_SCRIPTS_DIR="$HOME/.local/bin"

# Clone dotfiles repo
echo "Cloning dotfiles to $DOTFILES_DIR"

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# Ensure user scripts directory exists
echo "Ensuring $USER_SCRIPTS_DIR exists"

if [ ! -d "$USER_SCRIPTS_DIR" ]; then
    mkdir -p "$USER_SCRIPTS_DIR"
fi

# Symlink dotfiles bin to user scripts dir
echo "Symlinking dotfiles bin to $USER_SCRIPTS_DIR"

if [ -L "$USER_SCRIPTS_DIR/dotfiles" ]; then
    echo "Dotfiles symlink already exists"
elif [ -e "$USER_SCRIPTS_DIR/dotfiles" ]; then
    echo "Warning: File exists at $USER_SCRIPTS_DIR/dotfiles, skipping symlink"
else
    ln -s "$DOTFILES_BIN" "$USER_SCRIPTS_DIR/dotfiles"
    echo "Symlink created successfully"
fi

# Ensure $HOME/.local/bin is in PATH for current shell
if [[ ":$PATH:" != *":$USER_SCRIPTS_DIR:"* ]]; then
    export PATH="$USER_SCRIPTS_DIR:$PATH"
    echo "Added $USER_SCRIPTS_DIR to PATH"
fi

# Execute dotfiles bin
echo "Executing dotfiles bin"

"$DOTFILES_BIN"
