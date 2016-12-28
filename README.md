# linuxcmd
Setup my defaults in auto mode for any Linux.

Get script from this GIT and run (in the one line command):

* sudo bash -c "$(wget -q -O- https://raw.githubusercontent.com/applerom/linuxcmd/master/start.sh)"

or

* sudo MYSITE=_linux.cmd_ bash -c "$(wget -q -O- https://raw.githubusercontent.com/applerom/linuxcmd/master/start.sh)"

or

* sudo MYSITE=_linux.cmd_ bash -c -x "$(wget -q -O- https://raw.githubusercontent.com/applerom/linuxcmd/master/start.sh)" > 1.txt

For common use:

* cd /usr/local/src
* git clone https://github.com/applerom/linuxcmd
* cd linuxcmd
* chmod +x linuxcmd.sh

and

* ./linuxcmd.sh

or

* sudo bash ./linuxcmd.sh

p.s. Подробности на русском: https://linuxcmd.ru
