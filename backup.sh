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
#   LOCAL_DIRECTORY_TO_BACK_UP=/home/teddy
#   INCLUDE_EXCLUDE_CLAUSE="--include /home/teddy/backed_up --include /home/teddy/.bashrc --exclude /home/teddy"
#
# Ensure you record the values you put in ~/.duplicity/config encrypted and offsite somewhere.

source "$HOME/.duplicity/config"

export PASSPHRASE
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export S3_BUCKET_NAME
export LOCAL_DIRECTORY_TO_BACK_UP
export INCLUDE_EXCLUDE_CLAUSE


# To backup, run:
duplicity \
    --verbosity notice \
    --s3-use-new-style \
    --s3-use-ia \
    --s3-use-multiprocessing \
    --asynchronous-upload \
    --volsize 25 \
    --log-file ~/.duplicity/duplicity.log \
    $INCLUDE_EXCLUDE_CLAUSE \
    /home/teddy s3+http://$S3_BUCKET_NAME/


# To list files in backup, run:
# duplicity list-current-files \
#     --s3-use-new-style \
#     s3+http://$S3_BUCKET_NAME


# To restore, run `$ mkdir ~/duplicity-restore` then:
# duplicity restore \
#     --verbosity notice \
#     --s3-use-new-style \
#     [--time '2016-01-03'] \
#     [--file-to-restore foo/bar/baz.txt] \
#     s3+http://$S3_BUCKET_NAME ~/duplicity-restore/foo/bar/baz-restored.txt


unset PASSPHRASE
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset S3_BUCKET_NAME
unset LOCAL_DIRECTORY_TO_BACK_UP
unset INCLUDE_EXCLUDE_CLAUSE
