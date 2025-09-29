if test (uname) = "Darwin"
    # Setup Homebrew
    if not set -q HOMEBREW_PREFIX
        if test -e /opt/homebrew/bin/brew
            /opt/homebrew/bin/brew shellenv | source
        else if test -e /usr/local/bin/brew
            /usr/local/bin/brew shellenv | source
        else
            return 1
        end
    end

    # Add fish completions
    if test -e "$HOMEBREW_PREFIX/share/fish/completions"
        set --append fish_complete_path "$HOMEBREW_PREFIX/share/fish/completions"
    end

    # Other homebrew vars.
    set -q HOMEBREW_NO_ANALYTICS || set -gx HOMEBREW_NO_ANALYTICS 1

    # Reset pre-path
    set -q prepath && fish_add_path --prepend --move $prepath
end
