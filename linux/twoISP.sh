#!/bin/sh
set -e
LOCK=/var/tmp/routechanger.lock
IP=/sbin/ip

# List of IP's for pinger
LIST="/etc/sysconfig/list.ip"
# Timeout for ping
TIMEOUT=1

# First provider
DEV1=eth0
GATEWAY1=10.10.10.1
ISP_HOSTIP1=10.10.10.254
ISP_TABLE1=isp1
PING_TABLE1=isp1ping

# Second provider
DEV2=eth1
GATEWAY2=10.10.20.1
ISP_HOSTIP2=10.10.20.254
ISP_TABLE2=isp2
PING_TABLE2=isp2ping

# Networks
LAN1="192.168.2.0/24"
LAN2="192.168.3.0/24"


################################################################################################
############## Prepare procedure, add routes
############## $1 - Work table, $2 - Dev, $3 - Gateway, $4 - Host IP, $5 - Ping table
settable () {
        $IP route flush table $1
        $IP route show table main | grep -Ev "^default" | while read ROUTE; do
            $IP route add table $1 $ROUTE
        done
        $IP route add table $1 default dev $2 via $3
        while true; do
            ip rule del table $1 2>/dev/null || break
        done
}

######## Check lock file
if [ -f $LOCK ]; then
  echo Job is already running\!
  rm $LOCK
  exit 6
fi
touch $LOCK


######### Prepare pinger tables and networks
if [ "$1" == "-a" ]; then
        # Fill in tables
        settable $ISP_TABLE1 $DEV1 $GATEWAY1
        settable $ISP_TABLE2 $DEV2 $GATEWAY2
        settable $PING_TABLE1 $DEV1 $GATEWAY1
        settable $PING_TABLE2 $DEV2 $GATEWAY2
        # Map IP's for pinger
        $IP rule add from $ISP_HOSTIP1 table $PING_TABLE1
        $IP rule add from $ISP_HOSTIP2 table $PING_TABLE2
        # Map Networks to tables
        $IP rule add from $LAN1 table $ISP_TABLE1
        $IP rule add from $LAN2 table $ISP_TABLE2
        # Disabled, for traffic balacer
        #$IP route replace default scope global nexthop via $GATEWAY1 dev $DEV1 weight 1 nexthop via $GATEWAY2 dev $DEV2 weight 1
        $IP route flush cache

# Ping cheker & setter default routes
elif [ "$1" == "-p" ]; then
        TESTEDHOSTS1=`cat $LIST | while read in; do ping -c 1 -w $TIMEOUT -I $ISP_HOSTIP1 "$in" | grep "bytes from"; done | wc -l`
        TESTEDHOSTS2=`cat $LIST | while read in; do ping -c 1 -w $TIMEOUT -I $ISP_HOSTIP2 "$in" | grep "bytes from"; done | wc -l`

        # If both providers are available set default gates
        if [ $TESTEDHOSTS1 -ge 1 ] && [ $TESTEDHOSTS2 -ge 1 ]; then
                $IP route change default via $GATEWAY1 table $ISP_TABLE1
                $IP route change default via $GATEWAY2 table $ISP_TABLE2
        # If first provider unreacheble then change gates to second provider
        elif [ $TESTEDHOSTS1 -eq 0 ] && [ $TESTEDHOSTS2 -ge 1 ]; then
                $IP route change default via $GATEWAY2 table $ISP_TABLE1
                $IP route change default via $GATEWAY2 table $ISP_TABLE2
        # If second provider unreacheble then change gates to first provider
        elif [ $TESTEDHOSTS1 -ge 1 ] && [ $TESTEDHOSTS2 -eq 0 ]; then
                $IP route change default via $GATEWAY1 table $ISP_TABLE1
                $IP route change default via $GATEWAY1 table $ISP_TABLE2
        # If both providers are unavailable set default gates
        elif [ $TESTEDHOSTS1 -eq 0 ] && [ $TESTEDHOSTS2 -eq 0 ]; then
                $IP route change default via $GATEWAY1 table $ISP_TABLE1
                $IP route change default via $GATEWAY2 table $ISP_TABLE2
        fi
fi

# Remove lockfile
rm $LOCK
