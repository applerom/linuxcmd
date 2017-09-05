myprompt()
{
        if [ $? = 0 ]; then
                LASTOPER="GOOD"
        else
                LASTOPER="BAD"
        fi

        HOSTNAME=`hostname`
        tput setaf 4 # Set foreground color Blue
        # make flexible padding
        PADDING=`printf "%*s" $(($(tput cols)-24-${#HOSTNAME}-${#USER})) | sed "s| |_|g"`
        printf "$PADDING"
        
        if [ $LASTOPER == "GOOD" ]; then
                tput setaf 2 # Set foreground color Green
                printf " ✓ "
        else
                tput setaf 1 # Set foreground color Red
                tput bold
                printf " ✗ "
        fi

        tput sgr0 # Turn off all attributes

        if [[ $EUID == 0 ]]; then
                printf ""
        else
                tput setaf 1 # Set foreground color Red
                printf "$USER"
                tput setaf 7 # Set foreground color White
                printf "@"
        fi

        tput setaf 3 # Set foreground color Yellow
        printf "$HOSTNAME"

        tput setaf 4 # Set foreground color Blue
        printf " $(date +%F)"

        if [ $LASTOPER == "GOOD" ]; then
                tput setaf 2 # Set foreground color Green
        else
                tput setaf 1 # Set foreground color Red
                tput bold
        fi
                printf " $(date +%T)"
}
PS1='$(myprompt)\n \[\e[0;36m\]\w \[\e[01;32m\]\$\[\e[00m\] '

