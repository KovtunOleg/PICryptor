#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

BUCKET=$1
SECRET_KEY=$2

# show help if needed
if [[ $# -lt 2 ]]; then
  echo "Usage: pi_s3cmd_ls_dec s3://BUCKET[/PREFIX] SECRET_KEY"
  exit 1
fi

# list objects in Amazon S3 bucket
for ENC_FILE_NAME in $(s3cmd ls $BUCKET | awk -F"$BUCKET/" '{ print $NF }')
	do
	
	# decrypt file names
	echo $(pi_dec_filename.sh $ENC_FILE_NAME $SECRET_KEY)
done 