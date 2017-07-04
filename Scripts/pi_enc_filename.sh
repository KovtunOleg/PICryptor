#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

SECRET_KEY=$1
FILE_NAME=$2

# show help if needed
if [[ $# -lt 2 ]]; then
    echo "Usage: pi_enc_file.sh SECRET_KEY FILE_NAME"
    exit 1
fi

# return encrypted file name
echo `echo -n $FILE_NAME | openssl rc4 -nosalt -K $SECRET_KEY | base64 | sed "s/\//_/"g`