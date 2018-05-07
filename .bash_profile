# define global aliases used elsewhere
alias gcd=cd

# go dir
# dir - directory to find and navigate to
# function will change directory to the shortest path to the named directory, printing the full path when found
go() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        # display usage if no parameters given
        echo "usage: go [--help] [dir]"
        return
    else
        echo -e "$(tput setaf 1)leaving  $(tput sgr0)\c" && pwd
        if [[ "$1" == "home" || $# -eq 0 ]]; then
            # navigate to user's home
            gcd ~
        else
            # find shortest path to directory, go to it
            dir="$(find ~ -iname $1 | sort -n | head -n1)"
            if [[ $dir ]]; then
                gcd $dir
            else
                echo "-bash: go: $1: No such file or directory"
                return
            fi
        fi
        echo -e "$(tput setaf 2)entering $(tput sgr0)\c" && pwd
        ls
    fi
}

# refresh
# function uses `go` to navigate to refresh repo folder, change background, and return the user home. Reloads the dock.
refresh() {
    # navigate to application directory
    go refresh
    cd wallpapers

    # refresh once
    cp "$(ls | sort --random-sort | head -n1)" ../wallpaper.jpg
    sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '/Users/brycehawthorne/Documents/projects/refresh/wallpaper.jpg'";
    killall Dock

    # clean up terminal
    go home
    clear
}