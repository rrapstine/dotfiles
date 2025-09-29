function add_path
    # Add each argument to PATH using fish_add_path
    for path in $argv
        fish_add_path --prepend --global $argv
    end
end
