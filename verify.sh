#!/bin/bash
set -eou pipefail

# You can use this command to find 5 random files which you can then run this script individually on:
# find /path/to/your/local/directory/to/back_up -type f | shuf -n5
# TODO: write a script which wraps finding these 5 random files and verifies them

source "$HOME/.duplicity/config"

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export S3_BUCKET_NAME
export LOCAL_DIRECTORY_TO_BACK_UP
export BACKUP_NAME

RELATIVE_PATH_TO_VERIFY=$1

duplicity verify \
    --name $BACKUP_NAME \
    --verbosity Notice \
    --compare-data \
    --file-to-restore "$RELATIVE_PATH_TO_VERIFY" \
    s3://s3.amazonaws.com/$S3_BUCKET_NAME "$LOCAL_DIRECTORY_TO_BACK_UP/$RELATIVE_PATH_TO_VERIFY"

unset PASSPHRASE
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset S3_BUCKET_NAME
unset LOCAL_DIRECTORY_TO_BACK_UP
unset BACKUP_NAME
