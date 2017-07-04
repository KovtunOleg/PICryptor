#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

SECRET_KEY=$1
INPUT_FILE_PATH=$2
OUTPUT_DIR_PATH=$3

# show help if needed
if [[ $# -lt 3 ]]; then
    echo "Usage: pi_enc_file.sh SECRET_KEY INPUT_FILE_PATH OUTPUT_DIR_PATH"
    exit 1
fi

FILE_DIR=$(dirname $INPUT_FILE_PATH)
FILE_NAME=$(basename $INPUT_FILE_PATH)

# encrypt file name with openssl rc4+base64
cd $FILE_DIR
OUTPUT_FILE_PATH=$OUTPUT_DIR_PATH/$(pi_enc_filename.sh $SECRET_KEY $FILE_NAME)

# encrypt file content with openssl rc4
openssl rc4 -in $FILE_NAME -nosalt -K $SECRET_KEY > $OUTPUT_FILE_PATH

# return encrypted file path
echo $OUTPUT_FILE_PATH
