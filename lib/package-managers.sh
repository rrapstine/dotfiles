#!/bin/bash

# Package manager abstraction layer

source "$(dirname "${BASH_SOURCE[0]}")/detect.sh"

install_packages() {
    local os="$1"
    local packages_file="$2"
    
    case "$os" in
        macos)
            install_homebrew_packages "$packages_file"
            ;;
        arch)
            install_arch_packages "$packages_file"
            ;;
        *)
            log_error "Unsupported OS: $os"
            return 1
            ;;
    esac
}

install_homebrew_packages() {
    local brewfile="$1"
    
    log_info "Installing Homebrew packages from $brewfile"
    
    # Check if Homebrew is installed
    if ! has_command brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(detect_architecture) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    
    # Update Homebrew
    brew update
    
    # Install packages from Brewfile
    if [[ -f "$brewfile" ]]; then
        brew bundle --file "$brewfile" -v
        log_success "Homebrew packages installed successfully"
    else
        log_error "Brewfile not found: $brewfile"
        return 1
    fi
}

install_arch_packages() {
    local packages_file="$1"
    
    log_info "Installing Arch packages from $packages_file"
    
    if [[ ! -f "$packages_file" ]]; then
        log_error "Packages file not found: $packages_file"
        return 1
    fi
    
    # Update system
    sudo pacman -Syu --noconfirm
    
    # Install packages
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip empty lines and comments
        [[ -z "$package" || "$package" =~ ^#.* ]] && continue
        
        if [[ "$package" =~ ^aur: ]]; then
            # AUR package
            local aur_package="${package#aur:}"
            install_aur_package "$aur_package"
        else
            # Official repository package
            sudo pacman -S --needed --noconfirm "$package"
        fi
    done < "$packages_file"
    
    log_success "Arch packages installed successfully"
}

install_aur_package() {
    local package="$1"
    
    # Check if yay is installed
    if ! has_command yay; then
        log_info "Installing yay AUR helper..."
        
        # Install base-devel if not present
        sudo pacman -S --needed --noconfirm base-devel git
        
        # Clone and install yay
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd - > /dev/null
    fi
    
    log_info "Installing AUR package: $package"
    yay -S --needed --noconfirm "$package"
}