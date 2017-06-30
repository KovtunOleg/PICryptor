#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

FILE_PATH=$1
BUCKET=$2
SECRET_KEY=$3

# show help if needed
if [[ $# -lt 3 ]]; then
  echo "Usage: pi_s3cmd_put_enc.sh FILE [FILE...] s3://BUCKET[/PREFIX] SECRET_KEY"
  exit 1
fi

# transform the file (content and name) before uploading to S3
ENC_FILE_PATH=$(pi_enc_file.sh $FILE_PATH $PWD $SECRET_KEY)

# upload to Amazon S3
s3cmd put $ENC_FILE_PATH $BUCKET

# remove temporary file
rm -f $ENC_FILE_PATH