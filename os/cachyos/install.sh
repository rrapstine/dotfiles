#!/bin/bash

# CachyOS-specific installation script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$DOTFILES_ROOT/lib/detect.sh"
source "$DOTFILES_ROOT/lib/package-managers.sh"
source "$DOTFILES_ROOT/lib/utils.sh"

install_cachyos() {
    log_info "Setting up CachyOS environment..."
    
    # Optimize CachyOS mirrors first
    optimize_cachyos_mirrors
    
    # Update system first
    log_info "Updating system packages..."
    sudo pacman -Syu --noconfirm
    
    # Install packages with CachyOS priority
    install_cachyos_packages "$SCRIPT_DIR/packages.txt"
    
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
    
    log_success "CachyOS setup completed!"
}

optimize_cachyos_mirrors() {
    log_info "Optimizing CachyOS mirror configuration..."
    
    if has_command cachyos-rate-mirrors; then
        sudo cachyos-rate-mirrors
        log_success "CachyOS mirrors optimized"
    else
        log_warn "cachyos-rate-mirrors not found, skipping optimization"
    fi
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
    install_cachyos
fi