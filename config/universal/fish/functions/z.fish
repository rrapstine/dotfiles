function z
    # Call original zoxide command
    command z $argv

    # Run eza after jumping into the new directory
    and eza -x --group-directories-first --icons
end
