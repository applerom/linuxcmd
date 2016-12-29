sudo hostname $MYSITE
echo -e $OS_VER_SHOW
df -k | awk '$NF=="/"{printf "Disk Usage: %s\n", $5}'

## EOF