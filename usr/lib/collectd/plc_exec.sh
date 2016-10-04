#!/bin/sh

INTERFACE=$1

INTERFACE=${INTERFACE:="br-lan"}
#default-value for INTERVAL
INTERVAL=${COLLECTD_INTERVAL:=30}
# COLLECTD_INTERVAL may have trailing decimal places, but sleep rejects floating point.
INTERVAL=$(printf %.0f $INTERVAL)

LASTCHR=$((5+1))

while true; do

  #get data from amprate-tool. for each connection there are 2 lines (RX/TX)
  sudo amprate -i $INTERFACE |
    while IFS= read -r line
    do

    #for each line get parameter to variables
    echo "$line" | {
      IFS=' ' read -r iface src dst typ speed size primary 

      #convert string to number
      speed=${speed#0}

      #remove : from mac-addresses
      src=${src//[:]/}
      dst=${dst//[:]/}

      #shorten addresses
      src=$(echo $src|tail -c$LASTCHR)
      dst=$(echo $dst|tail -c$LASTCHR)

      #write data to collectd
      echo "PUTVAL \"$COLLECTD_HOSTNAME/exec-plc/plc_${typ}-${src}_${dst}\" interval=$INTERVAL N:$speed"

  }


  done
  sleep $INTERVAL
done
