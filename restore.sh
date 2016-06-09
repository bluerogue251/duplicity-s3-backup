#!/bin/bash
set -eou pipefail

source "$HOME/.duplicity/config"

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export S3_BUCKET_NAME
export BACKUP_NAME

RELATIVE_PATH_TO_RESTORE=$1
DIR_TO_RESTORE_TO=$2
TIME=${3-now}


mkdir $DIR_TO_RESTORE_TO

duplicity restore \
    --name $BACKUP_NAME \
    --verbosity Notice \
    --s3-use-new-style \
    --time "$TIME" \
    --file-to-restore $RELATIVE_PATH_TO_RESTORE \
    s3://s3.amazonaws.com/$S3_BUCKET_NAME $DIR_TO_RESTORE_TO


unset PASSPHRASE
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset S3_BUCKET_NAME
unset BACKUP_NAME
