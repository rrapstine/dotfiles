function update --description 'Update all packages'
    if test (uname) = Darwin
        brew update && brew upgrade
    else
        sudo pacman -Syu
    end
end
