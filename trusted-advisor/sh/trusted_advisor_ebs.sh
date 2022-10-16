#!/bin/bash

REGIONS=/tmp/aws_regions

aws ec2 describe-regions | grep RegionName | cut -d'"' -f4 > ${REGIONS}
echo "################################################################################"
echo "# EBS Volumes (unmounted)"

while read REGION; do
    echo ">> region : ${REGION}"

    aws configure set default.region ${REGION}

    aws ec2 describe-volumes  --filters Name=status,Values=available --query 'Volumes[*].{ID:VolumeId,AZ:AvailabilityZone,Size:Size,State:State}'  --output table
done < ${REGIONS}

echo "################################################################################"