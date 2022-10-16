#!/usr/bin/env bash

aws configure set default.region ap-northeast-2

BUCKETS_LIST=(`aws s3api list-buckets --output text | grep BUCKETS | cut -f3`)
PUBLIC_READ_BUCKETS=()
PUBLIC_WRITE_BUCKETS=()

for BUCKET_NAME in "${BUCKETS_LIST[@]}"; do

  PUBLIC_ACL_INDICATOR="http://acs.amazonaws.com/groups/global/AllUsers"
  printf "%s\n" ">> bucket : ${BUCKET_NAME}"

  if echo `aws s3api get-bucket-acl --output text --bucket ${BUCKET_NAME} | grep -A1 READ` | grep -q "${PUBLIC_ACL_INDICATOR}"
    then
      printf "%s\n" "Bucket ${BUCKET_NAME} allows Everyone to list its objects!"
      PUBLIC_READ_BUCKETS+=(${BUCKET_NAME})
  fi

  if echo `aws s3api get-bucket-acl --output text --bucket ${BUCKET_NAME} | grep -A1 WRITE` | grep -q "${PUBLIC_ACL_INDICATOR}"
    then
      printf "%s\n" "Bucket ${BUCKET_NAME} allows Everyone to write objects!"
      PUBLIC_WRITE_BUCKETS+=(${BUCKET_NAME})
  fi
done

printf "%s\n" ""
printf "%s\n" "Buckets with READ permission issues (if any):"
printf "%s\n" "${PUBLIC_READ_BUCKETS[@]}"

printf "%s\n" ""
printf "%s\n" "Buckets with WRITE permission issues (if any):"
printf "%s\n" "${PUBLIC_WRITE_BUCKETS[@]}"