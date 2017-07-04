#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

UNENCRYPTED_DIR_PATH="${SRCROOT}/${PROJECT_NAME}/s3_bucket_unencrypted" # your own path to unencrypted folder
ENCRYPTED_DIR_PATH="${SRCROOT}/${PROJECT_NAME}/s3_bucket" # your own path to encrypted folder
SECRET_KEY=E86A53E1E6B5E1321615FD9FB90A7CAA # your own secret key for openssl (can be found in picryptor_key.swift file)
ENC_FILE_SH="${SRCROOT}/Scripts/pi_enc_file.sh" # your own path to pi_enc_file.sh script

# create encrypted dyrectory if needed
mkdir -p $ENCRYPTED_DIR_PATH

# encrypt all files in unencrypted directory
cd $UNENCRYPTED_DIR_PATH
for FILE_NAME in *
    do
    sh $ENC_FILE_SH $SECRET_KEY $PWD/$FILE_NAME $ENCRYPTED_DIR_PATH
done
