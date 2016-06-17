#!/bin/bash

slack_url= [Webhook URL]
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
        \"title\": \"${subject%%:*}\",
        \"color\": \"${color}\",
        \"text\": \"${message}\"
    }
  ]
}"

# Posting message to slack
curl -m 5 --data-urlencode "${payload}" "${slack_url}"
