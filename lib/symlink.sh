#!/bin/bash

# Stow-like symlink management system

source "$(dirname "${BASH_SOURCE[0]}")/detect.sh"

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

create_symlinks() {
    local os="$1"

    log_info "Auto-discovering configs and scripts for OS: $os"

    # Auto-discover bin scripts
    if [[ -d "$DOTFILES_ROOT/bin" ]]; then
        log_info "Auto-discovering bin scripts..."
        for script in "$DOTFILES_ROOT/bin"/*; do
            [[ -f "$script" ]] || continue
            local script_name="$(basename "$script")"
            create_symlink "bin/$script_name" "$HOME/.local/bin/$script_name"
        done
    fi

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

    # Link shared Linux configs for any Linux distro
    if [[ "$os" =~ ^(arch|debian|redhat|linux)$ ]]; then
        local linux_config_dir="$DOTFILES_ROOT/config/linux"
        if [[ -d "$linux_config_dir" ]]; then
            for config_dir in "$linux_config_dir"/*; do
                [[ -d "$config_dir" ]] || continue
                local config_name="$(basename "$config_dir")"
                auto_link_config "config/linux/$config_name" "$config_name"
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

    # Simple rule: ALL configs go to $HOME/.config/{app_name} - no exceptions
    create_symlink "$source" "$HOME/.config/$config_name"
}

backup_existing_file() {
    local file="$1"
    local backup_dir="$HOME/.config/_backups"
    local filename="$(basename "$file")"
    local backup="$backup_dir/${filename}.backup.$(date +%Y%m%d_%H%M%S)"

    # Create backup directory if it doesn't exist
    if [[ ! -d "$backup_dir" ]]; then
        log_info "Creating backup directory: $backup_dir"
        mkdir -p "$backup_dir"
    fi

    log_info "Backing up existing file: $file -> $backup"
    mv "$file" "$backup"
}

remove_symlinks() {
    local os="$1"

    log_info "Removing auto-discovered symlinks for OS: $os"

    # Remove bin scripts
    if [[ -d "$DOTFILES_ROOT/bin" ]]; then
        for script in "$DOTFILES_ROOT/bin"/*; do
            [[ -f "$script" ]] || continue
            local script_name="$(basename "$script")"
            local target="$HOME/.local/bin/$script_name"
            if [[ -L "$target" ]]; then
                log_info "Removing symlink: $target"
                rm "$target"
            fi
        done
    fi

    # Remove universal configs
    if [[ -d "$DOTFILES_ROOT/config/universal" ]]; then
        for config_dir in "$DOTFILES_ROOT/config/universal"/*; do
            [[ -d "$config_dir" ]] || continue
            local config_name="$(basename "$config_dir")"
            local target="$HOME/.config/$config_name"
            if [[ -L "$target" ]]; then
                log_info "Removing symlink: $target"
                rm "$target"
            fi
        done
    fi

    # Remove OS-specific configs
    local os_config_dir="$DOTFILES_ROOT/config/$os"
    if [[ -d "$os_config_dir" ]]; then
        for config_dir in "$os_config_dir"/*; do
            [[ -d "$config_dir" ]] || continue
            local config_name="$(basename "$config_dir")"
            local target="$HOME/.config/$config_name"
            if [[ -L "$target" ]]; then
                log_info "Removing symlink: $target"
                rm "$target"
            fi
        done
    fi

    # Remove shared Linux configs
    if [[ "$os" =~ ^(arch|debian|redhat|linux)$ ]]; then
        local linux_config_dir="$DOTFILES_ROOT/config/linux"
        if [[ -d "$linux_config_dir" ]]; then
            for config_dir in "$linux_config_dir"/*; do
                [[ -d "$config_dir" ]] || continue
                local config_name="$(basename "$config_dir")"
                local target="$HOME/.config/$config_name"
                if [[ -L "$target" ]]; then
                    log_info "Removing symlink: $target"
                    rm "$target"
                fi
            done
        fi
    fi
}

remove_single_config() {
    local config_name="$1"
    local os="$2"

    log_info "Removing symlinks for config: $config_name"

    # Check and remove from bin
    local bin_target="$HOME/.local/bin/$config_name"
    if [[ -L "$bin_target" ]]; then
        local source_path="$(readlink "$bin_target")"
        if [[ "$source_path" == "$DOTFILES_ROOT/bin/$config_name" ]]; then
            log_info "Removing bin symlink: $bin_target"
            rm "$bin_target"
        fi
    fi

    # Check and remove from .config
    local config_target="$HOME/.config/$config_name"
    if [[ -L "$config_target" ]]; then
        local source_path="$(readlink "$config_target")"
        if [[ "$source_path" =~ ^$DOTFILES_ROOT/config/ ]]; then
            log_info "Removing config symlink: $config_target"
            rm "$config_target"
        fi
    fi
}

clean_broken_symlinks() {
    log_info "Cleaning broken symlinks..."
    
    local broken_count=0
    
    # Clean broken symlinks in ~/.local/bin
    if [[ -d "$HOME/.local/bin" ]]; then
        while IFS= read -r -d '' symlink; do
            if [[ ! -e "$symlink" ]]; then
                log_info "Removing broken symlink: $symlink"
                rm "$symlink"
                ((broken_count++))
            fi
        done < <(find "$HOME/.local/bin" -type l -print0 2>/dev/null)
    fi
    
    # Clean broken symlinks in ~/.config
    if [[ -d "$HOME/.config" ]]; then
        while IFS= read -r -d '' symlink; do
            if [[ ! -e "$symlink" ]]; then
                log_info "Removing broken symlink: $symlink"
                rm "$symlink"
                ((broken_count++))
            fi
        done < <(find "$HOME/.config" -type l -print0 2>/dev/null)
    fi
    
    if [[ $broken_count -eq 0 ]]; then
        log_success "No broken symlinks found"
    else
        log_success "Removed $broken_count broken symlink(s)"
    fi
}
