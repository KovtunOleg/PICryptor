#!/bin/bash

# show help if needed
if [[ $# -lt 1 ]]; then
    echo "Usage: install.sh SECRET_KEY"
    exit 1
fi

# create symlinks for PICryptor scrypts
BIN=/usr/local/bin
rm -f $BIN/pi_s3cmd_put_enc.sh
rm -f $BIN/pi_enc_file.sh
ln -s $PWD/pi_s3cmd_put_enc.sh $BIN/pi_s3cmd_put_enc.sh
ln -s $PWD/pi_enc_file.sh $BIN/pi_enc_file.sh
chmod +x $BIN/pi_s3cmd_put_enc.sh
chmod +x $BIN/pi_enc_file.sh

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
