MYUSER=ec2-user
MYHOME=/home/$MYUSER
if [ -z ${MYSITE+z} ]; then
	MYSITE=my.amilinux # enter name (DNS) of your system here
fi
OS_VER_SHOW=""
AUTOEXEC_FILE=".bashrc"
MYSH=/etc/profile.d/my.sh
#MYCERT_DIR=$MYHOME/certs
MYCERT_DIR=/root/certs
#SUDOMC="sudo -H mc"
REPLACE_VIM_WITH_NANO=yes
USE_INTERNAL_EDITOR_FOR_MC=no
