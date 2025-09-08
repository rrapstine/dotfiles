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

# Function to check SSH setup with GitHub
check_ssh() {
    echo "Checking SSH authentication with GitHub..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "SSH is already set up with GitHub."
    else
        echo "SSH is not set up with GitHub. Setting it up now..."
        setup_ssh
    fi
}

# Function to set up SSH keys
setup_ssh() {
    # Check if an ED25519 SSH key already exists
    if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
        echo "No ED25519 SSH key found. Generating a new SSH key..."
        ssh-keygen -t ed25519 -C "your_email@example.com" -N "" -f "$HOME/.ssh/id_ed25519"
    else
        echo "ED25519 SSH key already exists. Skipping key generation."
    fi

    # Display the public key
    echo "Copy the following SSH public key to your GitHub account:"
    cat "$HOME/.ssh/id_ed25519.pub"

    echo "Once you have added the key to https://github.com/settings/keys, press Enter to continue."
    read -p ""
}

# Ensure SSH is set up before cloning Fish repository
check_ssh

# Ensure that my fish config is pulled down into the proper location
if [[ -d "$HOME/.config/fish" ]]; then
  echo "Fish is already configured"
else
  git clone git@github.com:rrapstine/fish.git $HOME/.config/fish
fi

# Set fish as default shell
sudo chsh -s /opt/homebrew/bin/fish $USER

# Clone my neovim config down
if [[ -d "$HOME/.config/nvim" ]]; then
    echo "Neovim is already configured"
else
    git clone git@github.com:rrapstine/nvim.git $HOME/.config/nvim
fi

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
