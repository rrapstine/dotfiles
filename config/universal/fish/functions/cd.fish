function cd --description 'list files in the current directory after changing to it'
    if count $argv >/dev/null
        # prevents recurse infinitely by using built-in cd
        builtin cd "$argv"; and eza -x --git --group-directories-first --icons
    else
        # builtin cd ~; and eza -lagh --icons --group-directories-first
        builtin cd ~; and eza -x --git --group-directories-first --icons
    end
end
