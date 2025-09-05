#!/bin/sh

echo "Setting up your Mac..."

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
else
  echo "Xcode Command Line Tools already installed."
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file $DOTFILES/Brewfile -v

# Ensure that my fish config is pulled down into the proper location
if [[ -d "$HOME/.config/fish" ]]; then
  echo "Fish is already configured"
else
  git clone git@github.com:rrapstine/fish.git $HOME/.config/fish
fi

# Set fish as default shell
sudo chsh -s /opt/homebrew/bin/fish $USER

# Create a Code directory and subdirectories
mkdir $HOME/Code
mkdir $HOME/Code/projects
mkdir $HOME/Code/scripts
mkdir $HOME/Code/templates

# Clone Github repositories
# $DOTFILES/clone.sh

# Symlink the Mackup config file to the home directory
ln -s $DOTFILES/.mackup.cfg $HOME/.mackup.cfg

# Set dock using dockutil
sh dock.sh

# Set macOS preferences - we will run this last because this will reload the shell
source $DOTFILES/.macos
