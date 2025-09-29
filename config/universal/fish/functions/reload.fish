function reload --description 'Reload the entire configuration'
    for file in $CONFIG/fish/**/*.fish
        source $file
    end
end
