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

# generate picryptor_key.swift
echo $1 | awk '{ s = "// this is an auto generated file\n\n \
import Foundation\n \
// for openssl you use: -K "$1" \
let PICryptorSecretKey = Data(bytes: [0x"; for (i=1;i<length($0);i+=2) s = s substr($0,i,2) ", 0x"; s = substr(s,1,length(s)-4); s = s "])\n\n"; \
print s \
"public extension NSData { \
    public static func piCryptorSecretKey() -> NSData { \
        return PICryptorSecretKey as NSData \
    } \
}"}' > picryptor_key.swift
