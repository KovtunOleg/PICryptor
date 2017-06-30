#!/bin/bash

# create symlinks for PICryptor scrypts and make them executable out of the box
BIN=/usr/local/bin
chmod u+x genkey.sh
scripts=( "pi_s3cmd_ls_dec.sh" "pi_s3cmd_put_enc.sh" "pi_s3cmd_get_dec.sh" "pi_enc_file.sh" "pi_enc_filename.sh" "pi_dec_file.sh" "pi_dec_filename.sh" )
for script in "${scripts[@]}"
    do
    rm -f $BIN/$script
    ln -s $PWD/$script $BIN/$script
    chmod u+x $BIN/$script
done
