#!/bin/bash

# Arch Linux-specific installation script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$DOTFILES_ROOT/lib/detect.sh"
source "$DOTFILES_ROOT/lib/package-managers.sh"
source "$DOTFILES_ROOT/lib/utils.sh"

install_arch() {
    log_info "Setting up Arch Linux environment..."
    
    # Update system first
    log_info "Updating system packages..."
    sudo pacman -Syu --noconfirm
    
    # Install packages
    install_arch_packages "$SCRIPT_DIR/packages.txt"
    
    # Ensure SSH is set up
    ensure_ssh_setup
    
    # Clone personal repositories
    clone_personal_repos
    
    # Create necessary directories
    create_directories \
        "$HOME/Code" \
        "$HOME/Code/projects" \
        "$HOME/Code/scripts" \
        "$HOME/Code/templates"
    
    # Set fish as default shell
    if has_command fish; then
        set_default_shell "/usr/bin/fish"
    fi
    
    # Enable systemd services if specified
    if [[ -f "$SCRIPT_DIR/services.txt" ]]; then
        enable_services "$SCRIPT_DIR/services.txt"
    fi
    
    log_success "Arch Linux setup completed!"
}

clone_personal_repos() {
    log_info "Cloning personal configuration repositories..."
    
    # Fish shell config
    clone_or_update_repo "git@github.com:rrapstine/fish.git" "$HOME/.config/fish"
    
    # Neovim config
    clone_or_update_repo "git@github.com:rrapstine/nvim.git" "$HOME/.config/nvim"
    
    # WezTerm config (if using wezterm)
    if has_command wezterm; then
        clone_or_update_repo "git@github.com:rrapstine/wezterm.git" "$HOME/.config/wezterm"
    fi
}

enable_services() {
    local services_file="$1"
    
    log_info "Enabling systemd services from $services_file"
    
    while IFS= read -r service || [[ -n "$service" ]]; do
        # Skip empty lines and comments
        [[ -z "$service" || "$service" =~ ^#.* ]] && continue
        
        log_info "Enabling service: $service"
        sudo systemctl enable "$service"
    done < "$services_file"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_arch
fi