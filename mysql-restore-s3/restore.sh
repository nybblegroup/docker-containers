#!/bin/bash
set -e

if [ "${S3_ACCESS_KEY_ID}" == "**None**" ]; then
  echo "Warning: You did not set the S3_ACCESS_KEY_ID environment variable."
fi

if [ "${S3_SECRET_ACCESS_KEY}" == "**None**" ]; then
  echo "Warning: You did not set the S3_SECRET_ACCESS_KEY environment variable."
fi

if [ "${S3_BUCKET}" == "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${MYSQL_HOST}" == "**None**" ]; then
  echo "You need to set the MYSQL_HOST environment variable."
  exit 1
fi

if [ "${MYSQL_USER}" == "**None**" ]; then
  echo "You need to set the MYSQL_USER environment variable."
  exit 1
fi

if [ "${MYSQL_PASSWORD}" == "**None**" ]; then
  echo "You need to set the MYSQL_PASSWORD environment variable or link to a container named MYSQL."
  exit 1
fi

if [ "${S3_IAMROLE}" != "true" ]; then
  # env vars needed for aws tools - only if an IAM role is not used
  export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
  export AWS_DEFAULT_REGION=$S3_REGION
fi

MYSQL_HOST_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"
DUMP_START_TIME=$(date +"%Y-%m-%dT%H%M%SZ")

echo "Syncing backup folder locally from S3 ..."
mkdir -p databases
aws s3 sync --quiet --ignore-glacier-warnings s3://$S3_BUCKET/$S3_PREFIX ./databases

cd databases

IFS=',' read -r -a DB_ARRAY <<< "$MYSQL_DATABASE"
IFS=',' read -r -a SOURCE_DB_ARRAY <<< "$SOURCE_DATABASE"

for index in "${!DB_ARRAY[@]}"
do
    DB=${DB_ARRAY[index]}
    DB_SOURCE=${SOURCE_DB_ARRAY[index]}

    echo "Processing db $DB from source $DB_SOURCE ..."

    # Find filename
    FILENAME=$(ls -t *${DB_SOURCE}* | head -1)
    gzip -d $FILENAME
    SQLFILE=${FILENAME%.gz}

    # Fixing definers
    sed -i -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/; s/DEFINER[ ]*=[ ]*[^*]*PROCEDURE/PROCEDURE/; s/DEFINER[ ]*=[ ]*[^*]*FUNCTION/FUNCTION/g' $SQLFILE

    echo "Importing database $DB from $SQLFILE ..."
    mysql $MYSQL_HOST_OPTS --execute="DROP DATABASE IF EXISTS $DB; CREATE DATABASE $DB;"
    mysql $MYSQL_HOST_OPTS $DB < $SQLFILE
done

echo "SQL restore finished"