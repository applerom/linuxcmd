#!/bin/bash

# check for root at first!"
if [[ $UID != 0 ]] ; then 
    echo "Run only under root! Add sudo at the begin and repeat your command again."
    echo "Ex.:"
    echo 'sudo MYSITE=my.amilinux bash -c "$(wget -q -O- https://raw.githubusercontent.com/applerom/myamilinux/master/start.sh)"'
    echo "=========================================================="
    exit 1
fi

# create tmp dir"
MY_TMP_DIR=$(mktemp -d /tmp/my_script.XXX) # create_tmp_dir
trap "rm -R ${MY_TMP_DIR}" SIGTERM SIGINT EXIT
if [[ ! -O ${MY_TMP_DIR} ]]; then # Check that the dir exists and is owned by our euid (root)
	echo "Unable to create temporary directory MY_TMP_DIR."
	echo "=========================================================="
	exit 1
fi
chmod 700 $MY_TMP_DIR

# check for git"
if ! which git > /dev/null 2> /dev/null ; then
    echo "___Install git"
    if which yum > /dev/null 2> /dev/null ; then
        yum install -y git
    fi
    if which apt-get > /dev/null 2> /dev/null ; then
        apt-get install -y git
    fi
    if which zypper > /dev/null 2> /dev/null ; then
        zypper install -y git
    fi
    echo "=========================================================="
fi

echo "___ clone from git to tmp $MY_TMP_DIR"
cd $MY_TMP_DIR
git clone https://github.com/applerom/linuxcmd
echo "=========================================================="

echo "___ start $MYSTART.sh from git"
cd linuxcmd
chmod +x linuxcmd.sh

./linuxcmd.sh
echo "=========================================================="

exit 0

## EOF
