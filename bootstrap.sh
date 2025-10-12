#!/bin/bash

# Dotfiles Bootstrap Script
# One-command setup for new machines

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions (matching existing style)
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_banner() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Dotfiles Bootstrap                        ║"
    echo "║                   One-Command Setup Script                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
}

show_git_install_instructions() {
    local os=$(uname -s)
    log_error "Git is not installed. Please install Git first:"
    echo
    
    case "$os" in
        Darwin*)
            echo "macOS:"
            echo "  xcode-select --install"
            echo "  # or"
            echo "  brew install git"
            ;;
        Linux*)
            if command -v apt-get >/dev/null 2>&1; then
                echo "Ubuntu/Debian:"
                echo "  sudo apt-get update && sudo apt-get install git"
            elif command -v pacman >/dev/null 2>&1; then
                echo "Arch Linux:"
                echo "  sudo pacman -S git"
            elif command -v dnf >/dev/null 2>&1; then
                echo "Fedora:"
                echo "  sudo dnf install git"
            elif command -v zypper >/dev/null 2>&1; then
                echo "openSUSE:"
                echo "  sudo zypper install git"
            else
                echo "Linux:"
                echo "  # Use your distribution's package manager"
                echo "  # Examples:"
                echo "  sudo apt-get install git    # Debian/Ubuntu"
                echo "  sudo pacman -S git          # Arch"
                echo "  sudo dnf install git        # Fedora"
            fi
            ;;
        *)
            echo "Unknown OS. Please install Git using your system's package manager."
            ;;
    esac
    echo
    echo "After installing Git, run this script again."
}

prompt_for_path() {
    local default_path="$HOME/Code/dotfiles"
    local user_input
    
    echo "Enter the path where you want to clone the dotfiles repository:"
    echo "Default: $default_path"
    echo -n "Path [$default_path]: "
    read -r user_input
    
    if [[ -z "$user_input" ]]; then
        echo "$default_path"
    else
        # Expand ~ to home directory
        echo "${user_input/#\~/$HOME}"
    fi
}

prompt_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    local response
    
    while true; do
        if [[ "$default" == "y" ]]; then
            echo -n "$prompt [Y/n]: "
        else
            echo -n "$prompt [y/N]: "
        fi
        read -r response
        
        # Handle empty input (use default)
        if [[ -z "$response" ]]; then
            response="$default"
        fi
        
        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                echo "Please enter 'yes' or 'no'."
                ;;
        esac
    done
}

handle_existing_dotfiles() {
    local dotfiles_path="$1"
    
    log_warn "Dotfiles directory already exists: $dotfiles_path"
    echo
    
    # Check if it's a git repository
    if [[ -d "$dotfiles_path/.git" ]]; then
        log_info "This appears to be a git repository."
        
        # Check if install.sh exists
        if [[ -f "$dotfiles_path/install.sh" ]]; then
            log_info "The install.sh script is present."
            echo
            log_warn "It looks like the dotfiles have already been bootstrapped."
            echo
            
            if ! prompt_yes_no "Do you want to rerun the bootstrap process?"; then
                log_info "Bootstrap cancelled. Exiting."
                exit 0
            fi
            
            echo
            log_info "Choose an option:"
            echo "1) Update existing repository (git pull) and run install.sh"
            echo "2) Remove and re-clone (fresh installation)"
            echo "3) Just run install.sh on existing files"
            echo
            
            while true; do
                echo -n "Choice [1-3]: "
                read -r choice
                
                case "$choice" in
                    1)
                        log_info "Updating existing repository..."
                        cd "$dotfiles_path"
                        git pull origin main || git pull origin master
                        return 0
                        ;;
                    2)
                        log_info "Removing existing directory..."
                        rm -rf "$dotfiles_path"
                        return 1  # Signal that we need to clone
                        ;;
                    3)
                        log_info "Running install.sh on existing files..."
                        return 0
                        ;;
                    *)
                        echo "Please enter 1, 2, or 3."
                        ;;
                esac
            done
        else
            log_warn "install.sh not found. This might not be a valid dotfiles repository."
            if ! prompt_yes_no "Remove and re-clone?"; then
                log_error "Cannot proceed without install.sh. Exiting."
                exit 1
            fi
            rm -rf "$dotfiles_path"
            return 1  # Signal that we need to clone
        fi
    else
        log_warn "Directory exists but is not a git repository."
        if ! prompt_yes_no "Remove it and clone fresh dotfiles?"; then
            log_error "Cannot proceed with existing directory. Exiting."
            exit 1
        fi
        rm -rf "$dotfiles_path"
        return 1  # Signal that we need to clone
    fi
}

clone_dotfiles() {
    local dotfiles_path="$1"
    local repo_url="https://github.com/rrapstine/dotfiles.git"
    
    log_info "Cloning dotfiles repository..."
    log_info "Source: $repo_url"
    log_info "Target: $dotfiles_path"
    echo
    
    # Create parent directory if it doesn't exist
    local parent_dir
    parent_dir="$(dirname "$dotfiles_path")"
    if [[ ! -d "$parent_dir" ]]; then
        log_info "Creating parent directory: $parent_dir"
        mkdir -p "$parent_dir"
    fi
    
    # Clone the repository
    if git clone "$repo_url" "$dotfiles_path"; then
        log_success "Repository cloned successfully!"
    else
        log_error "Failed to clone repository."
        log_error "Please check your internet connection and try again."
        exit 1
    fi
}

run_install_script() {
    local dotfiles_path="$1"
    
    log_info "Running dotfiles installation script..."
    echo
    
    # Navigate to dotfiles directory
    cd "$dotfiles_path"
    
    # Make sure install.sh is executable
    chmod +x install.sh
    
    # Run the install script with no arguments
    if ./install.sh; then
        echo
        log_success "Bootstrap completed successfully!"
        echo
        log_info "Your dotfiles are now installed and ready to use."
        log_info "You can now use the 'dotfiles' command for ongoing management:"
        echo "  • dotfiles status       # Show current symlink status"
        echo "  • dotfiles edit nvim    # Edit specific config"
        echo "  • dotfiles clean        # Clean broken symlinks"
        echo "  • dotfiles help         # Show all available commands"
        echo
        log_info "Restart your terminal or run 'exec \$SHELL' to use the dotfiles command"
    else
        log_error "Installation script failed."
        log_error "Please check the error messages above and try again."
        exit 1
    fi
}

main() {
    print_banner
    
    # Check if git is installed
    if ! command -v git >/dev/null 2>&1; then
        show_git_install_instructions
        exit 1
    fi
    
    log_success "Git is installed."
    echo
    
    # Prompt for dotfiles path
    local dotfiles_path
    dotfiles_path="$(prompt_for_path)"
    echo
    
    # Expand any ~ in the path
    dotfiles_path="${dotfiles_path/#\~/$HOME}"
    
    # Handle existing dotfiles directory
    local need_clone=true
    if [[ -d "$dotfiles_path" ]]; then
        if handle_existing_dotfiles "$dotfiles_path"; then
            need_clone=false
        fi
    fi
    
    # Clone if needed
    if [[ "$need_clone" == true ]]; then
        clone_dotfiles "$dotfiles_path"
    fi
    
    echo
    # Run the installation script
    run_install_script "$dotfiles_path"
}

# Handle Ctrl+C gracefully
trap 'echo; log_info "Bootstrap interrupted by user. Exiting."; exit 130' INT

# Run main function
main "$@"