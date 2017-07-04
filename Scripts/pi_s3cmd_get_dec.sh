#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

SECRET_KEY=$1
FILE_NAME=$2
BUCKET=$3

# show help if needed
if [[ $# -lt 3 ]]; then
  echo "Usage: pi_s3cmd_get_dec.sh SECRET_KEY FILE_NAME s3://BUCKET[/PREFIX]"
  exit 1
fi

# transform the file name before downloading from S3
ENC_FILE_NAME=$(pi_enc_filename.sh $SECRET_KEY $FILE_NAME)

# download from Amazon S3
s3cmd get $BUCKET/$ENC_FILE_NAME

# get an unencrypted content and filename
DEC_FILE_PATH=$(pi_dec_file.sh $SECRET_KEY $ENC_FILE_NAME $PWD)

# remove temporary file
rm -f $ENC_FILE_NAME