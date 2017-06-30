#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

FILE_NAME=$1
SECRET_KEY=$2

# show help if needed
if [[ $# -lt 2 ]]; then
    echo "Usage: pi_enc_file.sh FILE_NAME SECRET_KEY"
    exit 1
fi

# return encrypted file name
echo `echo -n $FILE_NAME | openssl rc4 -nosalt -K $SECRET_KEY | base64 | sed "s/\//_/"g`