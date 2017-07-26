#!/bin/bash

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin

SECRET_KEY=$1
FILE_NAME=$2
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# show help if needed
if [[ $# -lt 2 ]]; then
    echo "Usage: pi_enc_filename.sh SECRET_KEY FILE_NAME"
    exit 1
fi

# return encrypted file name
echo `echo -n $FILE_NAME | openssl rc4 -nosalt -K $SECRET_KEY | $SCRIPT_PATH/pi_base16.sh`