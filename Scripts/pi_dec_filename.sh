#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

FILE_NAME=$1
SECRET_KEY=$2

# show help if needed
if [[ $# -lt 2 ]]; then
    echo "Usage: pi_dec_filename.sh FILE_NAME SECRET_KEY"
    exit 1
fi

# return decrypted file name
echo `echo -n $FILE_NAME | sed "s/_/\//"g | base64 -D | openssl rc4 -d -nosalt -K $SECRET_KEY`
