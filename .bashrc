# If not running interactively, don't do anything
[ -z "$PS1" ] && return

default_username='ubuntu'
default_hostname='hostnam'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        MAGENTA=$(tput setaf 9)
        ORANGE=$(tput setaf 172)
        GREEN=$(tput setaf 190)
        PURPLE=$(tput setaf 141)
        WHITE=$(tput setaf 256)
    else
        MAGENTA=$(tput setaf 5)
        ORANGE=$(tput setaf 4)
        GREEN=$(tput setaf 2)
        PURPLE=$(tput setaf 1)
        WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

function git_info() {
    # check if we're in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return

    # quickest check for what branch we're on
    branch=$(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')

    # check if it's dirty (via github.com/sindresorhus/pure)
    dirty=$(git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ]&& echo -e "*")

    echo $WHITE" on "$PURPLE$branch$dirty
}

# Only show username/host if not default
function usernamehost() {
    if [ $USER != "$default_username" ] || [ $HOSTNAME != "$default_hostname" ]; then echo "${MAGENTA}$USER ${WHITE}at ${ORANGE}$HOSTNAME $WHITEin "; fi
}

# iTerm Tab and Title Customization and prompt customization
# http://sage.ucsc.edu/xtal/iterm_tab_customization.html

# Put the string " [bash]   hostname::/full/directory/path"
# in the title bar using the command sequence
# \[\e]2;[bash]   \h::\]$PWD\[\a\]

# Put the penultimate and current directory
# in the iterm tab
# \[\e]1;\]$(basename $(dirname $PWD))/\W\[\a\]

PS1="\[\e]2;$PWD\[\a\]\[\e]1;\]$(basename "$(dirname "$PWD")")/\W\[\a\]${BOLD}\$(usernamehost)\[$GREEN\]\w\$(git_info)\[$WHITE\]\n\$ \[$RESET\]"

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr//share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
