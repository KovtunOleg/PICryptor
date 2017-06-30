#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

FILE_NAME=$1
BUCKET=$2
SECRET_KEY=$3

# show help if needed
if [[ $# -lt 3 ]]; then
  echo "Usage: pi_s3cmd_get_dec.sh FILE_NAME s3://BUCKET[/PREFIX] SECRET_KEY"
  exit 1
fi

# transform the file name before downloading from S3
ENC_FILE_NAME=$(pi_enc_filename.sh $FILE_NAME $SECRET_KEY)

# download from Amazon S3
s3cmd get $BUCKET/$ENC_FILE_NAME

# get an unencrypted content and filename
DEC_FILE_PATH=$(pi_dec_file.sh $ENC_FILE_NAME $PWD $SECRET_KEY)

# remove temporary file
rm -f $ENC_FILE_NAME