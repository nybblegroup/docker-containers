FROM alpine:latest
LABEL maintainer="Leonardo Rodriguez <leonardo.rodriguez@nybblegroup.com>"

RUN apk add --update --no-cache py-pip mysql-client bash
RUN pip install awscli

ENV MYSQLDUMP_OPTIONS --routines=true --quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net_buffer_length=16384
ENV MYSQLDUMP_DATABASE --all-databases
ENV MYSQL_HOST **None**
ENV MYSQL_PORT 3306
ENV MYSQL_USER **None**
ENV MYSQL_PASSWORD **None**
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV S3_PREFIX 'backup'
ENV S3_FILENAME **None**
ENV MULTI_FILES no
ENV SCHEDULE **None**

ADD backup.sh backup.sh

CMD ["bash", "backup.sh"]