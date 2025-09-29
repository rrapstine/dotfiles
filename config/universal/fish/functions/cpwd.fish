function cpwd --description 'pwd copied to clipboard'
    if test (uname) = Darwin
        set -l clipboard_cmd pbcopy
    else
        set -l clipboard_cmd wl-copy
    end

    command pwd | tr -d '\n' | $clipboard_cmd; and echo 'pwd copied to clipboard'
end
