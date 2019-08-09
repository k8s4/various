#!/bin/bash
#ip $1
#command $2
#user $3
#password $4

usage(){
        echo "Usage: $0 ip/dns command login password"
        echo "	Commands:"
	echo "	device   - Model of router."
        echo "	date     - Date of firmware."
        echo "	release  - Version of firmware."
        echo "	hostname - Current hostname."
        echo "	cpuload  - Load of CPU."
        echo "	memtotal - Total memory"
        echo "	memfree  - Free memory"
        echo "	uptime   - Uptime in seconds"
        echo "	status   - Status of DynDNS."
        echo "	message  - Message from DynDNS service"
        exit 1
}

#TMP_FILE=/tmp/kineticgigaiitmp.tmp
RESULT=/tmp/kineticgigaiiresult.tmp
TIME_FILE=/tmp/kineticgigaiitime.tmp
SCRIPTPATH=/usr/local/scripts/zabbix
CURR_DATE=`date '+%s'`
DIFF_TIME=60

[[ $# -eq 0 ]] && usage
## Check file is exist
if [ ! -f $TIME_FILE ]; then
	echo "timeFF:$CURR_DATE" > $TIME_FILE	
fi

## Get time from file
last=`grep 'timeFF:' $TIME_FILE | cut -f2 -d':' | sed -e 's/^[ ]*//'`
#echo "curr: $CURR_DATE"
#echo "last: $last"
difftime=`echo $(($CURR_DATE-$last))`
#echo "diff: $difftime"

## If time is different more $DIFF_TIME
if [ $difftime -gt $DIFF_TIME ]; then
	echo "timeFF:$CURR_DATE" > $TIME_FILE
#	sed -r "s/^(timeFF:).*/\1$CURR_DATE/;T" $TMP_FILE > $TMP_FILE
	$SCRIPTPATH/kinetic-giga2.exp $1 $3 $4 > $RESULT
fi

grep -o -E "$2.*" $RESULT | cut -f2 -d':' | sed -e 's/^[ ]*//'

exit 0
