#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

UNENCRYPTED_DIR_PATH="${SRCROOT}/${PROJECT_NAME}/s3_bucket_unencrypted" # your own path to unencrypted folder
ENCRYPTED_DIR_PATH="${SRCROOT}/${PROJECT_NAME}/s3_bucket" # your own path to encrypted folder
SECRET_KEY_PATH="${SRCROOT}/${PROJECT_NAME}/Sources/picryptor_key.txt" # your own path to txt PICryptorKey

# create encrypted dyrectory if needed
mkdir -p $ENCRYPTED_DIR_PATH

# encrypt all files in unencrypted directory
cd $UNENCRYPTED_DIR_PATH
for FILE_NAME in *
    do
    enc_file.sh $PWD/$FILE_NAME $ENCRYPTED_DIR_PATH $(cat $SECRET_KEY_PATH)
done