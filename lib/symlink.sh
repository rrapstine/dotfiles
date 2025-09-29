#!/bin/bash

# Stow-like symlink management system

source "$(dirname "${BASH_SOURCE[0]}")/detect.sh"

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

create_symlinks() {
    local profile_file="$1"
    local os="$2"
    
    if [[ -n "$profile_file" && -f "$profile_file" ]]; then
        log_info "Creating symlinks based on $profile_file"
        
        # Parse profile file format
        while IFS='=' read -r source target || [[ -n "$source" ]]; do
            # Skip empty lines and comments
            [[ -z "$source" || "$source" =~ ^#.* ]] && continue
            
            # Remove any leading/trailing whitespace
            source=$(echo "$source" | xargs)
            target=$(echo "$target" | xargs)
            
            create_symlink "$source" "$target"
        done < <(grep -E "^[^#].*=" "$profile_file" 2>/dev/null || true)
    else
        # Auto-discover based on OS
        log_info "Auto-discovering configs for OS: $os"
        
        # Link universal configs (always)
        if [[ -d "$DOTFILES_ROOT/config/universal" ]]; then
            for config_dir in "$DOTFILES_ROOT/config/universal"/*; do
                [[ -d "$config_dir" ]] || continue
                local config_name="$(basename "$config_dir")"
                auto_link_config "config/universal/$config_name" "$config_name"
            done
        fi
        
        # Link OS-specific configs
        local os_config_dir="$DOTFILES_ROOT/config/$os"
        if [[ -d "$os_config_dir" ]]; then
            for config_dir in "$os_config_dir"/*; do
                [[ -d "$config_dir" ]] || continue
                local config_name="$(basename "$config_dir")"
                auto_link_config "config/$os/$config_name" "$config_name"
            done
        fi
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    
    # Expand variables
    target="${target/\$HOME/$HOME}"
    target="${target/\~/$HOME}"
    
    local source_path="$DOTFILES_ROOT/$source"
    
    if [[ ! -e "$source_path" ]]; then
        log_warn "Source path does not exist: $source_path"
        return 1
    fi
    
    # Create target directory if it doesn't exist
    local target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        log_info "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi
    
    # Check if target already exists
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ -L "$target" && "$(readlink "$target")" == "$source_path" ]]; then
            log_info "Symlink already exists: $target -> $source_path"
            return 0
        else
            log_warn "Target already exists: $target"
            backup_existing_file "$target"
        fi
    fi
    
    # Create the symlink
    log_info "Creating symlink: $target -> $source_path"
    ln -sf "$source_path" "$target"
    
    if [[ $? -eq 0 ]]; then
        log_success "Created symlink: $target"
    else
        log_error "Failed to create symlink: $target"
        return 1
    fi
}

auto_link_config() {
    local source="$1"
    local config_name="$2"
    
    # ALL configs go in $HOME/.config for consistency across operating systems
    case "$config_name" in
        "tmux")
            # tmux config file goes directly in .config/tmux/
            create_symlink "$source/tmux.conf" "$HOME/.config/tmux/tmux.conf"
            ;;
        "git")
            # Git config files go in .config/git/ (XDG compliant)
            create_symlink "$source" "$HOME/.config/git"
            ;;
        "hardware")
            # Hardware configs - link individual subdirectories
            if [[ -d "$DOTFILES_ROOT/$source/openrazer" ]]; then
                create_symlink "$source/openrazer" "$HOME/.config/openrazer"
            fi
            if [[ -d "$DOTFILES_ROOT/$source/polychromatic" ]]; then
                create_symlink "$source/polychromatic" "$HOME/.config/polychromatic"
            fi
            ;;
        *)
            # Default: ALL configs go to ~/.config/<name>
            create_symlink "$source" "$HOME/.config/$config_name"
            ;;
    esac
}

backup_existing_file() {
    local file="$1"
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    log_info "Backing up existing file: $file -> $backup"
    mv "$file" "$backup"
}

remove_symlinks() {
    local profile_file="$1"
    
    log_info "Removing symlinks based on $profile_file"
    
    if [[ ! -f "$profile_file" ]]; then
        log_error "Profile file not found: $profile_file"
        return 1
    fi
    
    while IFS='=' read -r source target || [[ -n "$source" ]]; do
        # Skip empty lines and comments
        [[ -z "$source" || "$source" =~ ^#.* ]] && continue
        
        # Remove any leading/trailing whitespace
        target=$(echo "$target" | xargs)
        
        # Expand variables
        target="${target/\$HOME/$HOME}"
        target="${target/\~/$HOME}"
        
        if [[ -L "$target" ]]; then
            log_info "Removing symlink: $target"
            rm "$target"
        fi
    done < <(grep -E "^[^#].*=" "$profile_file" 2>/dev/null || true)
}