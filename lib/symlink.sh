#!/bin/bash

# Stow-like symlink management system

source "$(dirname "${BASH_SOURCE[0]}")/detect.sh"

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

resolve_config_path() {
    local app="$1"
    local os="$2"
    
    # Priority: most specific → least specific
    local paths=(
        "config/$os/$app"           # arch/hyprland
        "config/linux/$app"         # linux/hyprland  
        "config/universal/$app"     # universal/nvim
    )
    
    for path in "${paths[@]}"; do
        if [[ -d "$DOTFILES_ROOT/$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    return 1
}

create_all_symlinks() {
    local os="$1"
    
    log_info "Creating symlinks for OS: $os"
    
    # Auto-discover bin scripts
    if [[ -d "$DOTFILES_ROOT/bin" ]]; then
        log_info "Linking bin scripts..."
        for script in "$DOTFILES_ROOT/bin"/*; do
            [[ -f "$script" ]] || continue
            local script_name="$(basename "$script")"
            create_symlink "bin/$script_name" "$HOME/.local/bin/$script_name"
        done
    fi
    
    # Get all unique config directories
    local all_configs=()
    
    # Add universal configs
    if [[ -d "$DOTFILES_ROOT/config/universal" ]]; then
        for config_dir in "$DOTFILES_ROOT/config/universal"/*; do
            [[ -d "$config_dir" ]] || continue
            all_configs+=("$(basename "$config_dir")")
        done
    fi
    
    # Add OS-specific configs
    local os_config_dir="$DOTFILES_ROOT/config/$os"
    if [[ -d "$os_config_dir" ]]; then
        for config_dir in "$os_config_dir"/*; do
            [[ -d "$config_dir" ]] || continue
            all_configs+=("$(basename "$config_dir")")
        done
    fi
    
    # Add Linux configs for Linux distros
    if [[ "$os" =~ ^(arch|debian|redhat|linux)$ ]]; then
        local linux_config_dir="$DOTFILES_ROOT/config/linux"
        if [[ -d "$linux_config_dir" ]]; then
            for config_dir in "$linux_config_dir"/*; do
                [[ -d "$config_dir" ]] || continue
                all_configs+=("$(basename "$config_dir")")
            done
        fi
    fi
    
    # Create symlinks for unique configs
    local unique_configs=($(printf '%s\n' "${all_configs[@]}" | sort -u))
    for config_name in "${unique_configs[@]}"; do
        create_single_symlink "$config_name" "$os"
    done
}

create_single_symlink() {
    local config_name="$1"
    local os="$2"
    
    local config_path="$(resolve_config_path "$config_name" "$os")"
    
    if [[ -z "$config_path" ]]; then
        log_error "Configuration '$config_name' not found for OS: $os"
        return 1
    fi
    
    log_info "Linking configuration: $config_name ($config_path)"
    
    # Check if it's a bin script
    if [[ "$config_path" == bin/* ]]; then
        create_symlink "$config_path" "$HOME/.local/bin/$config_name"
    else
        create_symlink "$config_path" "$HOME/.config/$config_name"
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
        
        # Post-symlink hooks
        local config_name="$(basename "$target")"
        if [[ "$config_name" == "bat" ]] && command -v bat &> /dev/null; then
            log_info "Rebuilding bat cache with themes..."
            bat cache --build 2>/dev/null || log_warn "Failed to rebuild bat cache"
        fi
    else
        log_error "Failed to create symlink: $target"
        return 1
    fi
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
    
    log_info "Removing symlinks for OS: $os"
    
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
    
    # Remove all config symlinks that point to dotfiles
    if [[ -d "$HOME/.config" ]]; then
        find "$HOME/.config" -maxdepth 1 -type l -exec readlink {} \; | while read -r link_target; do
            if [[ "$link_target" == "$DOTFILES_ROOT"* ]]; then
                local symlink_path="$(find "$HOME/.config" -maxdepth 1 -lname "$link_target")"
                if [[ -n "$symlink_path" ]]; then
                    log_info "Removing symlink: $symlink_path"
                    rm "$symlink_path"
                fi
            fi
        done
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

show_status() {
    local os="$1"
    echo "Dotfiles Status:"
    echo "=================="
    echo "Root: $DOTFILES_ROOT"
    echo "OS: $os"
    echo
    
    local found_symlinks=false
    
    # Check bin scripts
    echo "Bin Scripts:"
    if [[ -d "$DOTFILES_ROOT/bin" ]]; then
        for script in "$DOTFILES_ROOT/bin"/*; do
            [[ -f "$script" ]] || continue
            local script_name="$(basename "$script")"
            local target="$HOME/.local/bin/$script_name"
            if [[ -L "$target" && "$(readlink "$target")" == "$script" ]]; then
                echo "  ✓ $script_name"
                found_symlinks=true
            else
                echo "  ✗ $script_name (not linked)"
            fi
        done
    else
        echo "  (no bin directory)"
    fi
    
    echo
    echo "Config Directories:"
    
    # Show all available configs and their status
    local all_configs=()
    
    # Collect universal configs
    if [[ -d "$DOTFILES_ROOT/config/universal" ]]; then
        for config_dir in "$DOTFILES_ROOT/config/universal"/*; do
            [[ -d "$config_dir" ]] || continue
            all_configs+=("universal:$(basename "$config_dir")")
        done
    fi
    
    # Collect OS-specific configs
    local os_config_dir="$DOTFILES_ROOT/config/$os"
    if [[ -d "$os_config_dir" ]]; then
        for config_dir in "$os_config_dir"/*; do
            [[ -d "$config_dir" ]] || continue
            all_configs+=("$os:$(basename "$config_dir")")
        done
    fi
    
    # Collect Linux configs for Linux distros
    if [[ "$os" =~ ^(arch|debian|redhat|linux)$ ]]; then
        local linux_config_dir="$DOTFILES_ROOT/config/linux"
        if [[ -d "$linux_config_dir" ]]; then
            for config_dir in "$linux_config_dir"/*; do
                [[ -d "$config_dir" ]] || continue
                all_configs+=("linux:$(basename "$config_dir")")
            done
        fi
    fi
    
    # Display status for each config
    for config_entry in "${all_configs[@]}"; do
        IFS=':' read -r category config_name <<< "$config_entry"
        local target="$HOME/.config/$config_name"
        
        if [[ -L "$target" ]]; then
            local source_path="$(readlink "$target")"
            if [[ "$source_path" == "$DOTFILES_ROOT/config/$category/$config_name" ]]; then
                echo "  ✓ $config_name ($category)"
                found_symlinks=true
            else
                echo "  ✗ $config_name ($category) (linked elsewhere)"
            fi
        else
            echo "  ✗ $config_name ($category) (not linked)"
        fi
    done
    
    if [[ "$found_symlinks" == false ]]; then
        echo "  (no active symlinks found)"
    fi
}

show_list() {
    local os="$1"
    echo "Available Configurations:"
    echo "========================="
    
    # List bin scripts
    echo "Bin Scripts:"
    if [[ -d "$DOTFILES_ROOT/bin" ]]; then
        for script in "$DOTFILES_ROOT/bin"/*; do
            [[ -f "$script" ]] || continue
            local script_name="$(basename "$script")"
            echo "  $script_name"
        done
    else
        echo "  (none)"
    fi
    
    echo
    echo "Config Directories:"
    
    # List universal configs
    echo "  Universal:"
    if [[ -d "$DOTFILES_ROOT/config/universal" ]]; then
        for config_dir in "$DOTFILES_ROOT/config/universal"/*; do
            [[ -d "$config_dir" ]] || continue
            local config_name="$(basename "$config_dir")"
            echo "    $config_name"
        done
    else
        echo "    (none)"
    fi
    
    # List OS-specific configs
    echo "  $os:"
    local os_config_dir="$DOTFILES_ROOT/config/$os"
    if [[ -d "$os_config_dir" ]]; then
        for config_dir in "$os_config_dir"/*; do
            [[ -d "$config_dir" ]] || continue
            local config_name="$(basename "$config_dir")"
            echo "    $config_name"
        done
    else
        echo "    (none)"
    fi
    
    # List Linux configs for Linux distros
    if [[ "$os" =~ ^(arch|debian|redhat|linux)$ ]]; then
        echo "  Linux:"
        local linux_config_dir="$DOTFILES_ROOT/config/linux"
        if [[ -d "$linux_config_dir" ]]; then
            for config_dir in "$linux_config_dir"/*; do
                [[ -d "$config_dir" ]] || continue
                local config_name="$(basename "$config_dir")"
                echo "    $config_name"
            done
        else
            echo "    (none)"
        fi
    fi
}