#!/bin/sh

# info for cloudflare service 
cfToken=TOKEN
cfUser=USER
cfDomain=DOMAIN
cfDomainId=DOMAINID
cfSubDomain=SUBDOMAIN

# info for pushover service
poToken=TOKEN
poUser=USER
 
WAN_IP=`curl -s http://icanhazip.com` 

if [ -f wan_ip.txt ]; 
then
        OLD_WAN_IP=`cat /tmp/wan_ip.txt` 
else
        echo "No file exists, creating it."
        echo "" > /tmp/wan_ip.txt
        OLD_WAN_IP="" 
fi

if [ "$WAN_IP" = "$OLD_WAN_IP" ]; 
then
        echo "IP Unchanged"
        echo "WAN IP is $WAN_IP" 
else
        echo $WAN_IP > /tmp/wan_ip.txt
        echo "Updating DNS to $WAN_IP"
        # use -k if encounter certificate issues !!LESS SECURE!!
        curl -s -k https://www.cloudflare.com/api_json.html \
          -d 'a=rec_edit' \
          -d 'tkn=$cfToken' \
          -d 'email=$cfUser' \
          -d 'z=$cfDomain' \
          -d 'id=$cfDomainId' \
          -d 'type=A' \
          -d 'name=$cfSubDomain' \
          -d 'ttl=1' \
          -d 'content=$WAN_IP'

	# use -k if encounter certificate issues !!LESS SECURE!!
	curl -s -k \
	  --form-string "token=$poToken" \
	  --form-string "user=$poUser" \
	  --form-string "message= The IP changed to $WAN_IP" \
	  https://api.pushover.net/1/messages.json

fi

