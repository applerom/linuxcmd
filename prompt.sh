myprompt()
{
        if [ $? = 0 ]; then
                LASTOPER="GOOD"
        else
                LASTOPER="BAD"
        fi

        HOSTNAME=`hostname`
        tput setaf 4
        printf "%*s" $(($(tput cols)-24-${#HOSTNAME}-${#USER})) "" | sed "s| |_|g"

        if [ $LASTOPER == "GOOD" ]; then
                tput setaf 2
                printf " ✓ "
        else
                tput setaf 1
                tput bold
                printf " ✗ "
        fi

        tput sgr0

        if [[ $EUID == 0 ]]; then
                printf ""
        else
                tput setaf 1
                printf "$USER"
                tput setaf 7
                printf "@"
        fi

        tput setaf 3
        printf "$HOSTNAME"

        tput setaf 4
        printf " $(date +%F)"

        if [ $LASTOPER == "GOOD" ]; then
                tput setaf 2
        else
                tput setaf 1
                tput bold
        fi
                printf " $(date +%T)"
}
PS1='$(myprompt)\n \[\e[0;36m\]\w \[\e[01;32m\]\$\[\e[00m\] '

## EOF
