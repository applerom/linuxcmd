################################################################################
### \myamilinux\start.sh
################################################################################
MYSTART=myamilinux
if [ -z $1 ]; then
	MYNAME=my.amilinux
else
	MYNAME=$1
fi
echo "__________________________________________________________"
echo "MYNAME=$MYNAME"

echo "__________________________________________________________"
echo "check root"
echo "__________________________________________________________"
if [[ $UID != 0 ]] ; then 
	echo "Run only under root! Add sudo at the begin and repeat your command again."
	echo "Ex.:"
	echo 'sudo bash -c "$(wget -q -O- https://raw.githubusercontent.com/applerom/$MYSTART/master/start.sh)"'
	echo "=========================================================="
	exit 1
fi
echo "=========================================================="

echo "__________________________________________________________"
echo "create tmp dir"
echo "__________________________________________________________"
MY_TMP_DIR=$(mktemp -d /tmp/my_script.XXX) # create_tmp_dir
trap "rm -R ${MY_TMP_DIR}" SIGTERM SIGINT EXIT
if [[ ! -O ${MY_TMP_DIR} ]]; then # Check that the dir exists and is owned by our euid (root)
	echo "Unable to create temporary directory MY_TMP_DIR."
	exit 1
fi
chmod 700 $MY_TMP_DIR
echo "=========================================================="

echo "__________________________________________________________"
echo "check for git"
echo "__________________________________________________________"
if ! which git > /dev/null 2> /dev/null ; then
	echo "___Install git"
	yum install -y git
fi
echo "=========================================================="

echo "__________________________________________________________"
echo "clone from git to tmp $MY_TMP_DIR"
echo "__________________________________________________________"
cd $MY_TMP_DIR
git clone https://github.com/applerom/$MYSTART
echo "=========================================================="

echo "__________________________________________________________"
echo "start $MYSTART.sh from git"
echo "__________________________________________________________"
cd $MYSTART
chmod +x $MYSTART.sh
./$MYSTART.sh
echo "=========================================================="

echo "=========================================================="
echo "exit"
echo "=========================================================="
exit 0

### END ### \myamilinux\start.sh #############################################################################
