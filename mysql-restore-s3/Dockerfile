FROM alpine:3.12.0
LABEL maintainer="Leonardo Rodriguez <leonardo.rodriguez@nybblegroup.com>"

RUN apk add --update --no-cache py-pip mysql-client bash
RUN pip install awscli

ENV MYSQL_HOST **None**
ENV MYSQL_USER **None**
ENV MYSQL_PASSWORD **None**
ENV MYSQL_PORT 3306

ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**

ADD restore.sh restore.sh

CMD ["bash", "restore.sh"]