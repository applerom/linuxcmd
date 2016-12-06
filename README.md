# myamilinux
Setup my AMI Linux defaults in auto mode.

Get my scripts from this GIT and run (in the one line command):

* sudo bash -c "$(wget -q -O- https://raw.githubusercontent.com/applerom/myamilinux/master/start.sh)"

or

* sudo *MYSITE=_my.amilinux_* bash -c "$(wget -q -O- https://raw.githubusercontent.com/applerom/myamilinux/master/start.sh)"

or

* sudo *MYSITE=_my.amilinux_* bash -c -x "$(wget -q -O- https://raw.githubusercontent.com/applerom/myamilinux/master/start.sh)" > 1.txt

For common use:

* cd /usr/local/src
* git clone https://github.com/applerom/myamilinux
* cd myamilinux
* chmod +x myamilinux.sh

and

* ./myamilinux.sh

or

* sudo bash ./myamilinux.sh
