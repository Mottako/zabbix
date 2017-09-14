#!/bin/bash
zabbix_url='[ZABBIX URL]'
slack_url='[Webhook URL]'
subject=$1
message=$2
username=Zabbix

# Change message color depending on the subject
if [[ "${message}" == *'Normal "Generic"'* ]]; then
        color="#91bbfc"
elif [ "${subject%%:*}" == 'OK' ]; then
        color="good"
elif [ "${subject%%:*}" == 'PROBLEM' ]; then
        color="danger"
else
        color="#808080"
fi

# Delete double quote (") on the message
message=`echo ${message} | sed -e 's/"//g'`

# Message format
payload="payload={
    \"username\":\"${username}\",
    \"attachments\": [
        {
            \"fallback\": \"fallback\",
            \"text\": \"${zabbix_url}|Zabbix>\",
            \"color\": \"${color}\",
            \"fields\":[
                {
                    \"title\": \"${subject%%:*}\",
                    \"value\": \"${message}\",
                    \"short\": true
     
                }
            ]
        }
    ]
}"

# Posting message to slack
curl -s -m 5 --data-urlencode "${payload}" "${slack_url}"
