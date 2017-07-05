#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

SECRET_KEY=$1
FILE_PATH=$2
BUCKET=$3
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# show help if needed
if [[ $# -lt 3 ]]; then
  echo "Usage: pi_s3cmd_put_enc.sh SECRET_KEY FILE [FILE...] s3://BUCKET[/PREFIX]"
  exit 1
fi

# transform the file (content and name) before uploading to S3
ENC_FILE_PATH=$($SCRIPT_PATH/pi_enc_file.sh $SECRET_KEY $FILE_PATH $PWD)

# upload to Amazon S3
s3cmd put $ENC_FILE_PATH $BUCKET

# remove temporary file
rm -f $ENC_FILE_PATH