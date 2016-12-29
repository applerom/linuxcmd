#!/bin/bash

if [ -z ${MYSITE+z} ]; then
	MYSITE=linux.cmd # enter name (DNS) of your system here
fi

MYSH=/etc/profile.d/my.sh
MYCERT_DIR=/root/certs
#SUDOMC="sudo -H mc"
REPLACE_VIM_WITH_NANO=yes
USE_INTERNAL_EDITOR_FOR_MC=no

function source_my_inc_file {	
	if [ -f $1 ] ; then
		source $1
	else
		echo "Not found file $1"
		exit 1
	fi
}
# include all mandatory files, configs and default functions
source_my_inc_file colours.inc.sh
source_my_inc_file funcs.sh
#source_my_inc_file vars.cfg.sh

get_os_info
case $DIST_TYPE in
	debian)
        MYUSER=admin
		OS_VER_SHOW="Debian \`cat /etc/debian_version\`"
		AUTOEXEC_FILE=".bashrc"
        MY_LOG=syslog
        MPM=apt-get
	;;
	ubuntu)
        MYUSER=ubuntu
		OS_VER_SHOW=""
		AUTOEXEC_FILE=".profile"
        MY_LOG=syslog
        MPM=apt-get
	;;
	amzn)
		OS_VER_SHOW=""
		AUTOEXEC_FILE=".bashrc"
        MYUSER=ec2-user
        MY_LOG=messages
        MPM=yum
	;;
	centos)
		OS_VER_SHOW=$DIST
		AUTOEXEC_FILE=".bashrc"
        MYUSER=centos
        MY_LOG=messages
        MPM=yum
	;;
	*)
		whiptail --infobox "Not supported Linux for this script version"
		exit 1
	;;
esac
MYHOME=/home/$MYUSER

# Update / upgrade system"
function update_system {
    if [[ $DIST_TYPE == "amzn" || $DIST_TYPE == "centos" ]] ; then
        yum -y update
    else
        apt-get update
        apt-get upgrade -y
    fi
}

# Install useful packets
function useful_packets {
    $MPM install -y mc ftp bzip2 zip nano lynx wget telnet
}

# Set nice prompt (float wigth)
function set_myprompt {
    if ! grep -q "myprompt" $MYHOME/$AUTOEXEC_FILE ; then	# protect from repeated running
        cat prompt.sh >> $MYHOME/$AUTOEXEC_FILE
        cat prompt.sh >> /root/.bashrc
        if [ -z ${SUDOMC+z} ]; then						# add autostart mc if it was added in config
            echo $SUDOMC >> $MYHOME/$AUTOEXEC_FILE
        fi
    fi
}

# Create www dir and useful links"
function useful_links {
    mkdir -p /var/www
    ln -s /var/www $MYHOME			> /dev/null 2> /dev/null
    ln -s /etc $MYHOME				> /dev/null 2> /dev/null
    ln -s /usr/local/src $MYHOME	> /dev/null 2> /dev/null
    ln -s /var/log $MYHOME			> /dev/null 2> /dev/null
    ln -s /var/log/$MY_LOG $MYHOME	> /dev/null 2> /dev/null
}

# Create certs dir"
function certs_dir {
    mkdir -p $MYCERT_DIR
    ln -s $MYCERT_DIR $MYHOME		> /dev/null 2> /dev/null
}

# Nano tuning"
function nano_tuning {
    sed -i 's|color green|color brightgreen|' /usr/share/nano/xml.nanorc
    sed -i 's~(cat|cd|chmod|chown|cp|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~(apt-get|awk|cat|cd|chmod|chown|cp|cut|echo|env|export|grep|install|let|ln|make|mkdir|mv|rm|sed|set|tar|touch|umask|unset)~' /usr/share/nano/sh.nanorc

    if ! grep -q "/bin/nano" $MYHOME/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
        echo "SELECTED_EDITOR=/bin/nano" >> $MYHOME/.selected_editor
    fi
    if ! grep -q "/bin/nano" /root/.selected_editor > /dev/null 2> /dev/null ; then # protect from repeated running
        echo "SELECTED_EDITOR=/bin/nano" >> /root/.selected_editor
    fi
}

function vim_nano {
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
}

function internal_mcedit {
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
}

# Add /bin/false in to /etc/shells (for correct proftpd working)
function false_shells {
    if ! grep -q "/bin/false" /etc/shells ; then # protect from repeated running
        echo "/bin/false" >> /etc/shells
    fi
}

# Install custom script for startup"
function custom_script {
    if [ ! -f $MYSH ] ; then # protect from repeated running
        cat mysh_$DIST_TYPE.sh >> $MYSH
    else
        sed -i "s|^sudo hostname.*|sudo hostname $MYSITE|" $MYSH
    fi
}

function finish_actions {
    # Chown content of user's home directory
    chown -R $MYUSER:$MYUSER $MYHOME
}

update_system
useful_packets
set_myprompt
useful_links
certs_dir
vim_nano
internal_mcedit
false_shells
custom_script
finish_actions

exit 0

## EOF
