################################################################################
### \myamilinux\myamilinux.sh
################################################################################
source common.sh # include all mandatory files, configs and default functions

echo "__________________________________________________________"
echo "Update / upgrade system"
echo "__________________________________________________________"
yum -y update
echo "=========================================================="

echo "__________________________________________________________"
echo "Install useful packets"
echo "__________________________________________________________"
sudo yum install -y mc ftp lynx
echo "=========================================================="

echo "__________________________________________________________"
echo "Set nice prompt"
echo "__________________________________________________________"
MYPS1="PS1='" #init/begin
MYPS1+="$Blue"
MYPS1+="__________________________________________________________" # long string of _spaces_ for comfortable reading
MYPS1+=" \`if [ \$? = 0 ]; then echo \"$Checkmark\"; else echo \"$FancyX\" ; fi\`" # 0 or 1 of last operation
MYPS1+=" \`if [[ \$EUID == 0 ]]; then echo \"\"; else echo \"$Red\\u$White@\" ; fi\`" # show current user (or nothing for root)
MYPS1+="$Yellow\\H" # Hostname
MYPS1+=" $Blue$MyDateTime\n" # current time & date and new string
MYPS1+=" $Cyan\\w $GreenLight\\\$$NoColour " # current dir + $
MYPS1+="'" #end of PS1
if ! grep -q "df -k" $MYHOME/$AUTOEXEC_FILE ; then # protect from repeated running
	echo $MYPS1 >> $MYHOME/$AUTOEXEC_FILE
	if [ -z ${SUDOMC+z} ]; then
		echo $SUDOMC >> $MYHOME/$AUTOEXEC_FILE
	fi
	echo $MYPS1 >> /root/.bashrc
fi
echo "=========================================================="

echo "__________________________________________________________"
echo "create www dir and useful links"
echo "__________________________________________________________"
mkdir -p /var/www
mkdir -p $MYCERT_DIR
ln -s /var/www $MYHOME			> /dev/null 2> /dev/null
ln -s /etc $MYHOME				> /dev/null 2> /dev/null
ln -s /usr/local/src $MYHOME	> /dev/null 2> /dev/null
ln -s /var/log $MYHOME			> /dev/null 2> /dev/null
mkdir -p $MYCERT_DIR
ln -s $MYCERT_DIR $MYHOME		> /dev/null 2> /dev/null
echo "=========================================================="

echo "__________________________________________________________"
echo "Nano tuning"
echo "__________________________________________________________"
sed -i 's|color green|color brightgreen|' /usr/share/nano/xml.nanorc
sed -i 's~(cat|cd|chmod|chown|cp|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~(apt-get|awk|cat|cd|chmod|chown|cp|cut|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~' /usr/share/nano/sh.nanorc
if ! grep -q "/bin/nano" $MYHOME/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
	echo "SELECTED_EDITOR=/bin/nano" >> $MYHOME/.selected_editor
fi
if ! grep -q "/bin/nano" /root/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
	echo "SELECTED_EDITOR=/bin/nano" >> /root/.selected_editor
fi
if [[ $REPLACE_VIM_WITH_NANO == "yes" ]] ; then
	if [ -f /bin/vi_orig ] ; then # protect from repeated running
		rm /bin/vi	
		ln -s /usr/bin/nano /bin/vi
		rm /usr/bin/vim
		ln -s /usr/bin/nano /usr/bin/vim
	else
		mv /bin/vi /bin/vi_orig
		ln -s /usr/bin/nano /bin/vi
		mv /usr/bin/vim /usr/bin/vim_orig
		ln -s /usr/bin/nano /usr/bin/vim
	fi
fi
if [[ $USE_INTERNAL_EDITOR_FOR_MC == "no" ]] ; then
	if [ -f $MYHOME/.mc/ini ] ; then
		sed -i "s|^use_internal_edit=.*|use_internal_edit=0|" $MYHOME/.mc/ini
	else
		mkdir $MYHOME/.mc > /dev/null 2> /dev/null
		echo "[Midnight-Commander]" > $MYHOME/.mc/ini
		echo "use_internal_edit=0" >> $MYHOME/.mc/ini
	fi
	if [ -f /root/.mc/ini ] ; then
		sed -i "s|^use_internal_edit=.*|use_internal_edit=0|" /root/.mc/ini
	else
		mkdir /root/.mc > /dev/null 2> /dev/null
		echo "[Midnight-Commander]" > /root/.mc/ini
		echo "use_internal_edit=0" >> /root/.mc/ini
	fi
fi
echo "=========================================================="

echo "__________________________________________________________"
echo "Add /bin/false in to /etc/shells"
echo "__________________________________________________________"
if ! grep -q "/bin/false" /etc/shells ; then # protect from repeated running
	echo "/bin/false" >> /etc/shells
fi
echo "=========================================================="

echo "__________________________________________________________"
echo "Install custom script for startup"
echo "__________________________________________________________"
if [ ! -f $MYSH ] ; then # protect from repeated running
	cat <<EOF >>$MYSH
sudo hostname $MYSITE
df -k | awk '\$NF=="/"{printf "Disk Usage: %s\n", \$5}'
EOF
fi
echo "=========================================================="

chown -R $MYUSER:$MYUSER $MYHOME

echo "=========================================================="
echo "END of myamilinux.sh"
echo "=========================================================="

exit 0
### END ### \myamilinux\myamilinux.sh #############################################################################
