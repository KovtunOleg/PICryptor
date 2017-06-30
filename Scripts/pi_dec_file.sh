#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

INPUT_FILE_PATH=$1
OUTPUT_DIR_PATH=$2
SECRET_KEY=$3

# show help if needed
if [[ $# -lt 3 ]]; then
    echo "Usage: pi_dec_file.sh INPUT_FILE_PATH OUTPUT_DIR_PATH SECRET_KEY"
    exit 1
fi

FILE_DIR=$(dirname $INPUT_FILE_PATH)
FILE_NAME=$(basename $INPUT_FILE_PATH)

# decrypt file name with openssl rc4+base64
cd $FILE_DIR
OUTPUT_FILE_PATH=$OUTPUT_DIR_PATH/$(pi_dec_filename.sh $FILE_NAME $SECRET_KEY)

# decrypt file content with openssl rc4
openssl rc4 -in $FILE_NAME -nosalt -K $SECRET_KEY > $OUTPUT_FILE_PATH

# return decrypted file path
echo $OUTPUT_FILE_PATH
