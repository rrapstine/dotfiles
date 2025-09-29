#!/bin/bash

# Common utility functions

source "$(dirname "${BASH_SOURCE[0]}")/detect.sh"

ensure_ssh_setup() {
    log_info "Checking SSH authentication with GitHub..."
    
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        log_success "SSH is already set up with GitHub"
        return 0
    else
        log_warn "SSH is not set up with GitHub"
        
        # Check if SSH key exists
        if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
            log_info "Generating new SSH key..."
            read -p "Enter your email for SSH key: " email
            ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
        fi
        
        # Start SSH agent and add key
        eval "$(ssh-agent -s)"
        
        # Create/update SSH config
        local ssh_config="$HOME/.ssh/config"
        if [[ ! -f "$ssh_config" ]] || ! grep -q "Host \*" "$ssh_config"; then
            log_info "Creating SSH config..."
            cat >> "$ssh_config" << EOF
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
EOF
            
            # macOS specific
            if [[ "$(detect_os)" == "macos" ]]; then
                sed -i '' '/Host \*/a\
    UseKeychain yes
' "$ssh_config"
                ssh-add -K "$HOME/.ssh/id_ed25519" 2>/dev/null || ssh-add "$HOME/.ssh/id_ed25519"
            else
                ssh-add "$HOME/.ssh/id_ed25519"
            fi
        fi
        
        log_warn "Please add your SSH key to GitHub:"
        echo
        cat "$HOME/.ssh/id_ed25519.pub"
        echo
        read -p "Press Enter after adding the key to GitHub..."
        
        # Test again
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            log_success "SSH setup completed successfully"
        else
            log_error "SSH setup failed. Please check your GitHub configuration."
            return 1
        fi
    fi
}

clone_or_update_repo() {
    local repo_url="$1"
    local target_dir="$2"
    
    if [[ -d "$target_dir" ]]; then
        log_info "Repository already exists at $target_dir, pulling latest changes..."
        cd "$target_dir"
        git pull
        cd - > /dev/null
    else
        log_info "Cloning repository to $target_dir..."
        git clone "$repo_url" "$target_dir"
    fi
}

create_directories() {
    local directories=("$@")
    
    for dir in "${directories[@]}"; do
        # Expand variables
        dir="${dir/\$HOME/$HOME}"
        dir="${dir/\~/$HOME}"
        
        if [[ ! -d "$dir" ]]; then
            log_info "Creating directory: $dir"
            mkdir -p "$dir"
        fi
    done
}

set_default_shell() {
    local shell_path="$1"
    
    if [[ ! -f "$shell_path" ]]; then
        log_error "Shell not found: $shell_path"
        return 1
    fi
    
    local current_shell="$(basename "$SHELL")"
    local target_shell="$(basename "$shell_path")"
    
    if [[ "$current_shell" == "$target_shell" ]]; then
        log_info "Default shell is already $target_shell"
        return 0
    fi
    
    log_info "Setting default shell to $shell_path"
    
    # Add shell to /etc/shells if not present
    if ! grep -q "$shell_path" /etc/shells; then
        echo "$shell_path" | sudo tee -a /etc/shells
    fi
    
    # Change default shell
    sudo chsh -s "$shell_path" "$USER"
    log_success "Default shell changed to $target_shell"
}