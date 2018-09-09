#!/bin/bash

REGIONS=/tmp/aws_regions

aws ec2 describe-regions | grep RegionName | cut -d'"' -f4 > ${REGIONS}

echo "################################################################################"
echo "# EC2 Instances (Generated within 1 day / Stopped)"

while read REGION; do
    echo ">> region : ${REGION}"

    aws configure set default.region ${REGION}

    aws ec2 describe-instances --query "Reservations[].Instances[?LaunchTime>='`date +%Y-%m-%d -d 'yesterday'`'][].{id: InstanceId, type: InstanceType, launched: LaunchTime}" --output table
    aws ec2 describe-instances --filters Name=instance-state-name,Values=stopped --query "Reservations[].Instances[].{id: InstanceId, type: InstanceType, launched: LaunchTime, tag: Tags[0].Value}" --output table
 
done < ${REGIONS}
echo "################################################################################"