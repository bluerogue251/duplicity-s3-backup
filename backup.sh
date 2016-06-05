#!/bin/bash
set -eou pipefail

# Adapted from http://kappataumu.com/articles/cloud-backups-duplicity-s3.html
#
#
# Setup:
# $ sudo apt-get install python-software-properties
# $ sudo apt-get install software-properties-common
# $ sudo apt-add-repository ppa:duplicity-team/ppa
# $ sudo add-apt-repository ppa:chris-lea/python-boto
# $ sudo apt-get update
# $ sudo apt-get install duplicity python-boto haveged
#
#
# Set up an S3 bucket to use for backup.
# For lower AWS costs, set up a Lifecyle rule on the bucket to transition
# objects to "Standard - Infrequent Access" S3 Storage Class.
# Add an AWS user with permissions just for that bucket. Example IAM policy:
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
# $ mkdir ~/.duplicity
# $ touch ~/.duplicity/config
# $ chmod 600 ~/.duplicity/config
# $ sudo chown root ~/.duplicity/config
#
#
# Fill in ~/.duplicity/config with:
#   PASSPHRASE=<your_symmetric_encryption_passphrase>
#   AWS_ACCESS_KEY_ID=<your_aws_access_key>
#   AWS_SECRET_ACCESS_KEY=<your_aws_secret_access_key>
#   S3_BUCKET_NAME=<name_of_your_s3_bucket>
#   LOCAL_DIRECTORY_TO_BACK_UP=<your_local_directory_to_recursively_back_up>
#
# Ensure you record the values you put in ~/.duplicity/config encrypted and offsite somewhere.

source "$HOME/.duplicity/config"

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export S3_BUCKET_NAME
export LOCAL_DIRECTORY_TO_BACK_UP

duplicity \
    --verbosity notice \
    --s3-use-new-style \
    --asynchronous-upload \
    --volsize 25 \
    --log-file ~/.duplicity/duplicity.log \
    $LOCAL_DIRECTORY_TO_BACK_UP s3+http://$S3_BUCKET_NAME/

# To restore, run something like:
# duplicity restore \
#     --verbosity notice \
#     --s3-use-new-style \
#     [--time '2016-01-03'] \
#     [--file-to-restore foo/bar/baz.txt] \
#     s3+http://$S3_BUCKET_NAME $LOCAL_DIRECTORY_TO_RESTORE_TO

unset PASSPHRASE
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset S3_BUCKET_NAME
unset LOCAL_DIRECTORY_TO_BACK_UP
