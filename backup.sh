#!/bin/bash
set -eou pipefail

# Adapted from http://kappataumu.com/articles/cloud-backups-duplicity-s3.html
#
#
# Install dependencies:
# $ sudo apt-get install python-software-properties
# $ sudo apt-get install software-properties-common
# $ sudo apt-add-repository ppa:duplicity-team/ppa
# $ sudo add-apt-repository ppa:chris-lea/python-boto
# $ sudo apt-get update
# $ sudo apt-get install duplicity python-boto haveged
#
#
#
# Create an S3 bucket to use for backup.
# Add an AWS IAM user with permissions just for that bucket. Example IAM policy:
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": "s3:*",
#             "Resource": [
#                 "arn:aws:s3:::your-bucket-name/*"
#             ]
#         }
#     ]
# }
#
#
#
# Configure your backup:
#
# $ mkdir ~/.duplicity
# $ touch ~/.duplicity/config
# $ chmod 600 ~/.duplicity/config
# $ sudo chown root ~/.duplicity/config
#
# Fill in ~/.duplicity/config with:
#   PASSPHRASE=<your_symmetric_encryption_passphrase>
#   AWS_ACCESS_KEY_ID=<your_aws_iam_duplicity_user_access_key>
#   AWS_SECRET_ACCESS_KEY=<your_aws_iam_duplicity_user_secret_access_key>
#   S3_BUCKET_NAME=<name_of_your_s3_bucket>
#   LOCAL_DIRECTORY_TO_BACK_UP=/home/teddy
#   INCLUDE_EXCLUDE_CLAUSE="--include /home/teddy/backed_up --include /home/teddy/.bashrc --exclude /home/teddy"
#
# The above example recursively backs up /home/teddy/backed_up and /home/teddy/.bashrc and
# does not back up anything else on your machine.
#
# Make a encrypted, offsite backup of the values you put in ~/.duplicity/config. Make it separately
# from this duplicity backup. This way, if you ever lose access to your machine or to
# the ~/.duplicity/config file, you will still be able to restore and decrypt your backup elsewhere.

source "$HOME/.duplicity/config"

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export S3_BUCKET_NAME
export LOCAL_DIRECTORY_TO_BACK_UP
export INCLUDE_EXCLUDE_CLAUSE


# (The s3.amazonaws.com endpoint below assumes you chose US Standard / US East (N. Virginia) as your bucket region)
# To backup, run:
duplicity \
    --name trw-personal \
    --verbosity Notice \
    --progress \
    --progress-rate 60 \
    --s3-use-new-style \
    --s3-use-ia \
    --asynchronous-upload \
    --volsize 25 \
    --log-file ~/.duplicity/duplicity.log \
    $INCLUDE_EXCLUDE_CLAUSE \
    $LOCAL_DIRECTORY_TO_BACK_UP s3://s3.amazonaws.com/$S3_BUCKET_NAME


unset PASSPHRASE
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset S3_BUCKET_NAME
unset LOCAL_DIRECTORY_TO_BACK_UP
unset INCLUDE_EXCLUDE_CLAUSE
