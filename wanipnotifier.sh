#!/bin/sh
 
cfkey=KEY
cfuser=USER
cfhost=DOMAIN
 
WAN_IP=`curl -s http://icanhazip.com` 

if [ -f wan_ip-cf.txt ]; 
then
        OLD_WAN_IP=`cat /home/pi/myscripts/wan_ip-cf.txt` 
else
        echo "No file, need IP"
        OLD_WAN_IP="" 
fi

if [ "$WAN_IP" = "$OLD_WAN_IP" ]; 
then
        echo "IP Unchanged" 
else
        echo $WAN_IP > /home/pi/myscripts/wan_ip-cf.txt
        echo "Updating DNS to $WAN_IP"
        curl -s https://www.cloudflare.com/api.html?a=DIUP\&hosts="$cfhost"\&u="$cfuser"\&tkn="$cfkey"\&ip="$WAN_IP" > /dev/null

	curl -s \
	  --form-string "token=TOKEN" \
	  --form-string "user=USER" \
	  --form-string "message= The IP changed to $WAN_IP" \
	  https://api.pushover.net/1/messages.json

fi

