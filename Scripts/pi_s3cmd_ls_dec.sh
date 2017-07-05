#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

SECRET_KEY=$1
BUCKET=$2
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# show help if needed
if [[ $# -lt 2 ]]; then
  echo "Usage: pi_s3cmd_ls_dec SECRET_KEY s3://BUCKET[/PREFIX]"
  exit 1
fi

# list objects in Amazon S3 bucket
for ENC_FILE_NAME in $(s3cmd ls $BUCKET | awk -F"$BUCKET/" '{ print $NF }')
	do
	
	# decrypt file names
	echo $($SCRIPT_PATH/pi_dec_filename.sh $SECRET_KEY $ENC_FILE_NAME)
done 