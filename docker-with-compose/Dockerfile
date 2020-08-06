FROM docker:stable

ENV DOCKER_HOST tcp://docker:2375/
ENV DOCKER_DRIVER overlay2

RUN apk add --no-cache make libffi-dev openssl-dev python2-dev rsync py-pip gcc musl-dev

RUN pip install --upgrade pip && pip install docker-compose
