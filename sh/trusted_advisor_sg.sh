#!/bin/bash

REGIONS=/tmp/aws_regions

aws ec2 describe-regions | grep RegionName | cut -d'"' -f4 > ${REGIONS}

echo "################################################################################"
echo "# Security Group"

while read REGION; do
    echo ">> region : ${REGION}"

    aws configure set default.region ${REGION}
    SSH=`aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=22" | jq '.SecurityGroups[]'`
    if [ "${SSH}" != "" ]; then
            echo "# Security Group (Port:22 / CIDR:0.0.0.0/0)"
            aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=22"  --query 'SecurityGroups[?length(IpPermissions[?ToPort==`22` && contains(IpRanges[].CidrIp, `0.0.0.0/0`)]) > `0`].{GroupName: GroupName, TagName: Tags[?Key==`Name`].Value | [0]}' --output table
    fi

    SQL=`aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=3306" | jq '.SecurityGroups[]'`
    if [ "${SQL}" != "" ]; then
            echo "# Security Group (Port:3306 / CIDR:0.0.0.0/0)"
            aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=3306"  --query 'SecurityGroups[?length(IpPermissions[?ToPort==`3306` && contains(IpRanges[].CidrIp, `0.0.0.0/0`)]) > `0`].{GroupName: GroupName, TagName: Tags[?Key==`Name`].Value | [0]}' --output table
    fi


done < ${REGIONS}

echo "################################################################################"