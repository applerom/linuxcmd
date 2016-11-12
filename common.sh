################################################################################
### \myamilinux\common.sh
################################################################################

function source_my_inc_file {	
	if [ -f $1 ] ; then
		source $1
	else
		echo "Not found file $1"
		exit 1
	fi
}
source_my_inc_file vars.cfg.sh
source_my_inc_file colours.inc.sh

### END ### \myamilinux\common.sh #############################################################################
