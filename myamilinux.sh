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
sudomc="sudo -H mc"
if ! grep -q "$sudomc" $MYHOME/$AUTOEXEC_FILE ; then # protect from repeated running
	echo $MYPS1 >> $MYHOME/$AUTOEXEC_FILE
	echo "df -k | awk '\$NF==\"/\"{printf \"Disk Usage: %s\n\", \$5}'" >> $MYHOME/$AUTOEXEC_FILE
	echo $sudomc >> $MYHOME/$AUTOEXEC_FILE

	echo $MYPS1 >> /root/.bashrc
fi
echo "=========================================================="

echo "__________________________________________________________"
echo "create www dir and useful links"
echo "__________________________________________________________"
mkdir -p /var/www
ln -s /var/www $MYHOME
ln -s /etc $MYHOME
ln -s /usr/local/src $MYHOME
ln -s /var/log $MYHOME
echo "=========================================================="

echo "__________________________________________________________"
echo "Nano tuning"
echo "__________________________________________________________"
sed -i 's|color green|color brightgreen|' /usr/share/nano/xml.nanorc
sed -i 's~(cat|cd|chmod|chown|cp|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~(apt-get|awk|cat|cd|chmod|chown|cp|cut|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~' /usr/share/nano/sh.nanorc
if ! grep -q "/bin/nano" $MYHOME/.selected_editor ; then # protect from repeated running
	echo "SELECTED_EDITOR=/bin/nano" >> $MYHOME/.selected_editor
fi
if ! grep -q "/bin/nano" /root/.selected_editor ; then # protect from repeated running
	echo "SELECTED_EDITOR=/bin/nano" >> /root/.selected_editor
fi
mv /bin/vi /bin/vi_orig
ln -s /usr/bin/nano /bin/vi
mv /usr/bin/vim /usr/bin/vim_orig
ln -s /usr/bin/nano /usr/bin/vim
sed -i "s|^use_internal_edit=.*|use_internal_edit=0|" /root/.mc/ini
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
EOF
fi
echo "=========================================================="

echo "=========================================================="
echo "END of mydebian.sh"
echo "=========================================================="

exit 0
### END ### \myamilinux\myamilinux.sh #############################################################################
