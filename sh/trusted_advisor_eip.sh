#!/bin/bash

REGIONS=/tmp/aws_regions

aws ec2 describe-regions | grep RegionName | cut -d'"' -f4 > ${REGIONS}

echo "################################################################################"
echo "# Elastic IP (no associated)"

while read REGION; do
    echo ">> region : ${REGION}"

    aws configure set default.region ${REGION}

     aws ec2 describe-addresses --query 'Addresses[?AssociationId==null]' --output table
done < ${REGIONS}

echo "################################################################################"
