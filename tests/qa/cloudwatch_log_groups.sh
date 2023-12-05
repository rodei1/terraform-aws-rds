#!/bin/bash

aws logs describe-log-groups --region eu-central-1 | jq -r '.logGroups[].logGroupName' | while read file
do
    if [[ $file == "/aws/rds/instance/qa/postgresql" ]] || [[ $file == "/aws/rds/instance/qa/upgrade" ]] || [[ $file == "/aws/rds/proxy/qa" ]]
    then
        aws logs delete-log-group --log-group-name $file
    fi
done
