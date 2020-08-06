#!/bin/sh
set -e

FILENAME="${ZIP_FILENAME}.tgz"

# We backup the folder
echo "Backup folder to S3"
tar -czf $FILENAME -C ${FOLDER_TO_PROCESS} .
aws s3 cp $FILENAME s3://${S3_PATH}/$FILENAME
rm $FILENAME

if [ $OVERRIDE_FILES = "true" ]
then
    echo "Restoring files..."

    echo "Copy source file at s3://${S3_SOURCE_PATH}/$FILENAME"
    aws s3 cp s3://${S3_SOURCE_PATH}/$FILENAME $FILENAME 

    mkdir -p src
    tar -xzf $FILENAME -C src
    rsync -akzv --stats --progress --exclude="styles" --exclude="css" --exclude="js" src/ ${FOLDER_TO_PROCESS}

    # Backup file in S3 once processed
    echo "Move processed file to backup in S3 folder"
    aws s3 mv s3://${S3_SOURCE_PATH}/$FILENAME s3://${S3_SOURCE_PATH}/backups/$FILENAME
fi

echo "Process ended succesfully"