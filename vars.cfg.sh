MYHOME=/home/ec2-user
if [ -z ${MYSITE+z} ]; then
	MYSITE=my.amilinux # enter name (DNS) of your system here
fi
OS_VER_SHOW=
AUTOEXEC_FILE=".bashrc"
MYSH=/etc/profile.d/my.sh
MYCERT_DIR=$MYHOME/certs
