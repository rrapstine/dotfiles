#!/bin/bash

# OS and distribution detection utilities

detect_cachyos() {
    if [[ -f /etc/cachyos-release ]] || { [[ -f /usr/lib/os-release ]] && grep -q "CachyOS" /usr/lib/os-release 2>/dev/null; }; then
        return 0
    fi
    return 1
}

detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            if [ -f /etc/arch-release ]; then
                if detect_cachyos; then
                    echo "cachyos"
                else
                    echo "arch"
                fi
            elif [ -f /etc/debian_version ]; then
                echo "debian"
            elif [ -f /etc/redhat-release ]; then
                echo "redhat"
            else
                echo "linux"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

detect_architecture() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "x64"
            ;;
        arm64|aarch64)
            echo "arm64"
            ;;
        *)
            echo "$(uname -m)"
            ;;
    esac
}

has_command() {
    command -v "$1" >/dev/null 2>&1
}

log_info() {
    echo "ℹ️  $1"
}

log_success() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1" >&2
}

log_warn() {
    echo "⚠️  $1"
}