sudo hostname $MYSITE
df -k | awk '$NF=="/"{printf "Disk Usage: %s\n", $5}'

## EOF