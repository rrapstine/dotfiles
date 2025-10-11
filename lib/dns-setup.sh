#!/bin/bash

# DNS Setup for .test domains
# Supports Linux (systemd-resolved + dnsmasq) and macOS (system resolver)

# Source utility functions
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_ROOT/lib/detect.sh"

setup_dns_test_domains() {
    local os_type
    os_type=$(detect_os)

    log_info "Setting up .test domain resolution for $os_type"

    case "$os_type" in
        "macos")
            setup_macos_dns
            ;;
        "arch"|"cachyos"|"linux")
            setup_linux_dns
            ;;
        *)
            log_warn "DNS setup not supported for $os_type"
            return 1
            ;;
    esac
}

setup_linux_dns() {
    log_info "Configuring Linux DNS with systemd-resolved + dnsmasq"

    # Check if systemd-resolved is running
    if ! systemctl is-active --quiet systemd-resolved; then
        log_error "systemd-resolved is not running"
        return 1
    fi

    # Install dnsmasq if not present
    if ! has_command dnsmasq; then
        log_info "Installing dnsmasq..."
        case "$(detect_os)" in
            "arch"|"cachyos")
                sudo pacman -S --noconfirm dnsmasq
                ;;
            *)
                log_error "Package installation not supported for this Linux distribution"
                return 1
                ;;
        esac
    fi

    # Backup existing dnsmasq config
    if [[ -f /etc/dnsmasq.conf ]] && ! grep -q "# Configuration for .test domain forwarding" /etc/dnsmasq.conf; then
        log_info "Backing up existing dnsmasq configuration"
        sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.backup.$(date +%Y%m%d_%H%M%S)
    fi

    # Configure dnsmasq
    log_info "Configuring dnsmasq for .test domains"
    if ! grep -q "# Configuration for .test domain forwarding" /etc/dnsmasq.conf; then
        sudo tee -a /etc/dnsmasq.conf << 'EOF'

# Configuration for .test domain forwarding
address=/.test/127.0.0.1
port=5353
bind-interfaces
listen-address=127.0.0.1
no-hosts
no-resolv
cache-size=1000
EOF
    else
        log_info "DNS configuration already present in dnsmasq.conf"
    fi

    # Backup systemd-resolved config
    if [[ -f /etc/systemd/resolved.conf ]] && ! grep -q "DNS=127.0.0.1:5353" /etc/systemd/resolved.conf; then
        log_info "Backing up systemd-resolved configuration"
        sudo cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.backup.$(date +%Y%m%d_%H%M%S)
    fi

    # Configure systemd-resolved
    log_info "Configuring systemd-resolved"

    # Update or add DNS line
    if grep -q "^DNS=" /etc/systemd/resolved.conf; then
        sudo sed -i 's/^DNS=.*/DNS=127.0.0.1:5353/' /etc/systemd/resolved.conf
    else
        sudo sed -i '/^\[Resolve\]/a DNS=127.0.0.1:5353' /etc/systemd/resolved.conf
    fi

    # Add Domains line if not present
    if ! grep -q "^Domains=" /etc/systemd/resolved.conf; then
        if grep -q "^DNS=" /etc/systemd/resolved.conf; then
            sudo sed -i '/^DNS=/a Domains=~test' /etc/systemd/resolved.conf
        else
            sudo sed -i '/^\[Resolve\]/a Domains=~test' /etc/systemd/resolved.conf
        fi
    fi

    # Restart services
    log_info "Restarting services"
    sudo systemctl enable dnsmasq
    sudo systemctl restart dnsmasq
    sudo systemctl restart systemd-resolved

    # Wait a moment for services to start
    sleep 2

    # Test the setup
    if test_dns_resolution; then
        log_success "DNS setup completed successfully!"
        log_info "You can now use {projectname}.test domains in your browser and curl"
        log_info "Example: curl http://myproject.test:3000"
    else
        log_error "DNS setup verification failed"
        return 1
    fi
}

setup_macos_dns() {
    log_info "Configuring macOS DNS resolver for .test domains"

    # Create resolver directory
    sudo mkdir -p /etc/resolver

    # Configure .test domain resolver
    log_info "Creating .test domain resolver"
    sudo tee /etc/resolver/test << 'EOF'
nameserver 127.0.0.1
port 5353
EOF

    # Install dnsmasq via Homebrew
    if ! has_command dnsmasq; then
        log_info "Installing dnsmasq via Homebrew"
        if has_command brew; then
            brew install dnsmasq
        else
            log_error "Homebrew not found. Please install Homebrew first."
            return 1
        fi
    fi

    # Find dnsmasq config location
    local dnsmasq_conf="/usr/local/etc/dnsmasq.conf"
    if [[ ! -f "$dnsmasq_conf" ]] && [[ -f "/opt/homebrew/etc/dnsmasq.conf" ]]; then
        dnsmasq_conf="/opt/homebrew/etc/dnsmasq.conf"
    fi

    # Create config if it doesn't exist
    if [[ ! -f "$dnsmasq_conf" ]]; then
        sudo touch "$dnsmasq_conf"
    fi

    # Backup existing config
    if [[ -f "$dnsmasq_conf" ]] && ! grep -q "# Configuration for .test domain forwarding" "$dnsmasq_conf"; then
        log_info "Backing up existing dnsmasq configuration"
        sudo cp "$dnsmasq_conf" "$dnsmasq_conf.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Configure dnsmasq
    log_info "Configuring dnsmasq"
    if ! grep -q "# Configuration for .test domain forwarding" "$dnsmasq_conf"; then
        sudo tee -a "$dnsmasq_conf" << 'EOF'

# Configuration for .test domain forwarding
address=/.test/127.0.0.1
port=5353
bind-interfaces
listen-address=127.0.0.1
no-hosts
no-resolv
cache-size=1000
EOF
    else
        log_info "DNS configuration already present in dnsmasq.conf"
    fi

    # Start dnsmasq service
    log_info "Starting dnsmasq service"
    sudo brew services start dnsmasq

    # Wait a moment for service to start
    sleep 2

    # Test the setup
    if test_dns_resolution; then
        log_success "DNS setup completed successfully!"
        log_info "You can now use {projectname}.test domains in your browser and curl"
        log_info "Example: curl http://myproject.test:3000"
    else
        log_error "DNS setup verification failed"
        return 1
    fi
}

test_dns_resolution() {
    log_info "Testing DNS resolution..."

    # Test with dig if available
    if has_command dig; then
        local result
        result=$(dig +short testproject.test 2>/dev/null)
        if [[ "$result" == "127.0.0.1" ]]; then
            log_success "DNS resolution test passed with dig"
            return 0
        fi
    fi

    # Test with nslookup as fallback
    if has_command nslookup; then
        if nslookup testproject.test 2>/dev/null | grep -q "127.0.0.1"; then
            log_success "DNS resolution test passed with nslookup"
            return 0
        fi
    fi

    log_warn "DNS resolution test failed - but this might be normal on some systems"
    return 1
}

check_dns_status() {
    local os_type
    os_type=$(detect_os)

    log_info "Checking DNS setup status for $os_type"

    case "$os_type" in
        "macos")
            check_macos_dns_status
            ;;
        "arch"|"cachyos"|"linux")
            check_linux_dns_status
            ;;
        *)
            log_warn "DNS status check not supported for $os_type"
            return 1
            ;;
    esac
}

check_linux_dns_status() {
    echo "=== Linux DNS Status ==="

    # Check systemd-resolved
    if systemctl is-active --quiet systemd-resolved; then
        log_success "systemd-resolved is running"

        # Check configuration
        if grep -q "DNS=127.0.0.1:5353" /etc/systemd/resolved.conf; then
            log_success "systemd-resolved configured for .test domains"
        else
            log_warn "systemd-resolved not configured for .test domains"
        fi
    else
        log_error "systemd-resolved is not running"
    fi

    # Check dnsmasq
    if systemctl is-active --quiet dnsmasq; then
        log_success "dnsmasq is running"

        # Check if it's listening on port 5353
        if ss -tulpn | grep -q "127.0.0.1:5353"; then
            log_success "dnsmasq listening on port 5353"
        else
            log_warn "dnsmasq not listening on expected port 5353"
        fi

        # Check configuration
        if grep -q "address=/.test/127.0.0.1" /etc/dnsmasq.conf; then
            log_success "dnsmasq configured for .test domains"
        else
            log_warn "dnsmasq not configured for .test domains"
        fi
    else
        log_warn "dnsmasq is not running"
    fi

    # Test resolution
    test_dns_resolution
}

check_macos_dns_status() {
    echo "=== macOS DNS Status ==="

    # Check resolver file
    if [[ -f /etc/resolver/test ]]; then
        log_success "/etc/resolver/test exists"
        if grep -q "nameserver 127.0.0.1" /etc/resolver/test; then
            log_success "Resolver configured correctly"
        else
            log_warn "Resolver configuration may be incorrect"
        fi
    else
        log_warn "/etc/resolver/test does not exist"
    fi

    # Check dnsmasq
    if brew services list | grep -q "dnsmasq.*started"; then
        log_success "dnsmasq service is running"
    else
        log_warn "dnsmasq service is not running"
    fi

    # Check if dnsmasq is listening
    if lsof -i :5353 | grep -q dnsmasq; then
        log_success "dnsmasq listening on port 5353"
    else
        log_warn "dnsmasq not listening on port 5353"
    fi

    # Test resolution
    test_dns_resolution
}

remove_dns_setup() {
    local os_type
    os_type=$(detect_os)

    log_info "Removing .test domain DNS setup for $os_type"

    case "$os_type" in
        "macos")
            remove_macos_dns
            ;;
        "arch"|"cachyos"|"linux")
            remove_linux_dns
            ;;
        *)
            log_warn "DNS removal not supported for $os_type"
            return 1
            ;;
    esac
}

remove_linux_dns() {
    log_info "Removing Linux DNS configuration"

    # Remove dnsmasq configuration
    if grep -q "# Configuration for .test domain forwarding" /etc/dnsmasq.conf; then
        log_info "Removing dnsmasq .test configuration"
        sudo sed -i '/# Configuration for .test domain forwarding/,$d' /etc/dnsmasq.conf
    fi

    # Reset systemd-resolved configuration
    if grep -q "DNS=127.0.0.1:5353" /etc/systemd/resolved.conf; then
        log_info "Resetting systemd-resolved DNS configuration"
        sudo sed -i 's/^DNS=127.0.0.1:5353/DNS=/' /etc/systemd/resolved.conf
    fi

    if grep -q "^Domains=~test" /etc/systemd/resolved.conf; then
        log_info "Removing systemd-resolved Domains configuration"
        sudo sed -i '/^Domains=~test/d' /etc/systemd/resolved.conf
    fi

    # Restart services
    log_info "Restarting services"
    sudo systemctl restart systemd-resolved
    sudo systemctl stop dnsmasq
    sudo systemctl disable dnsmasq

    log_success "Linux DNS setup removed successfully"
}

remove_macos_dns() {
    log_info "Removing macOS DNS configuration"

    # Remove resolver file
    if [[ -f /etc/resolver/test ]]; then
        log_info "Removing /etc/resolver/test"
        sudo rm -f /etc/resolver/test
    fi

    # Stop dnsmasq service
    if has_command brew; then
        log_info "Stopping dnsmasq service"
        sudo brew services stop dnsmasq
    fi

    # Find and clean dnsmasq config
    local dnsmasq_conf="/usr/local/etc/dnsmasq.conf"
    if [[ ! -f "$dnsmasq_conf" ]] && [[ -f "/opt/homebrew/etc/dnsmasq.conf" ]]; then
        dnsmasq_conf="/opt/homebrew/etc/dnsmasq.conf"
    fi

    if [[ -f "$dnsmasq_conf" ]] && grep -q "# Configuration for .test domain forwarding" "$dnsmasq_conf"; then
        log_info "Removing dnsmasq .test configuration"
        sudo sed -i '' '/# Configuration for .test domain forwarding/,$d' "$dnsmasq_conf"
    fi

    log_success "macOS DNS setup removed successfully"
}
