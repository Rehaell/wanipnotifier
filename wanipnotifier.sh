#!/bin/sh
# create a file called wan_ip-cf.txt on /tmp/
# info for cloudflare service 
cfkey=KEY
cfuser=USER
cfhost=DOMAIN

# info for pushover service
potoken=TOKEN
pouser=USER
 
WAN_IP=`curl -s http://icanhazip.com` 

if [ -f wan_ip-cf.txt ]; 
then
        OLD_WAN_IP=`cat /tmp/wan_ip-cf.txt` 
else
        echo "No file, need IP"
        OLD_WAN_IP="" 
fi

if [ "$WAN_IP" = "$OLD_WAN_IP" ]; 
then
        echo "IP Unchanged"
        echo "WAN IP is $WAN_IP" 
else
        echo $WAN_IP > /tmp/wan_ip-cf.txt
        echo "Updating DNS to $WAN_IP"
        curl -s https://www.cloudflare.com/api.html?a=DIUP\&hosts="$cfhost"\&u="$cfuser"\&tkn="$cfkey"\&ip="$WAN_IP" > /dev/null

	curl -s \
	  --form-string "token=$potoken" \
	  --form-string "user=$pouser" \
	  --form-string "message= The IP changed to $WAN_IP" \
	  https://api.pushover.net/1/messages.json

fi

