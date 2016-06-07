#!/bin/bash
#!/bin/bash
set -eou pipefail

source "$HOME/.duplicity/config"

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export S3_BUCKET_NAME
export LOCAL_DIRECTORY_TO_BACK_UP
export INCLUDE_EXCLUDE_CLAUSE


duplicity \
    --dry-run \
    --name trw-personal \
    --verbosity 8 \
    $INCLUDE_EXCLUDE_CLAUSE \
    $LOCAL_DIRECTORY_TO_BACK_UP s3://s3.amazonaws.com/$S3_BUCKET_NAME


unset PASSPHRASE
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset S3_BUCKET_NAME
unset LOCAL_DIRECTORY_TO_BACK_UP
unset INCLUDE_EXCLUDE_CLAUSE
