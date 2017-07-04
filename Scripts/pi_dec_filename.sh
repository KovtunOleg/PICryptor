#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

SECRET_KEY=$1
FILE_NAME=$2

# show help if needed
if [[ $# -lt 2 ]]; then
    echo "Usage: pi_dec_filename.sh SECRET_KEY FILE_NAME"
    exit 1
fi

# return decrypted file name
echo `echo -n $FILE_NAME | sed "s/_/\//"g | base64 -D | openssl rc4 -d -nosalt -K $SECRET_KEY`
