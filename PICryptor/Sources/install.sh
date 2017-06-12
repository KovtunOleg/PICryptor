#!/bin/bash

# show help if needed
if [[ $# -lt 1 ]]; then
    echo "Usage: install.sh SECRET_KEY"
    exit 1
fi

# create symlinks for PICryptor scrypts
BIN=/usr/local/bin
unlink $BIN/s3cmd_put_enc.sh
unlink $BIN/enc_file.sh
ln -s $PWD/s3cmd_put_enc.sh $BIN/s3cmd_put_enc.sh
ln -s $PWD/enc_file.sh $BIN/enc_file.sh
chmod +x $BIN/s3cmd_put_enc.sh
chmod +x $BIN/enc_file.sh

# create txt PICryptorKey
echo $1 > picryptor_key.txt

# generate swift PICryptorKey
cat picryptor_key.txt | awk '{ s = "// this is an auto generated file\n\nimport Foundation\n\nlet PICryptorKey = Data(bytes: [0x"; for (i=1;i<length($0);i+=2) s = s substr($0,i,2) ", 0x"; s = substr(s,1,length(s)-4); s = s "])"; print s }' > picryptor_key.swift
