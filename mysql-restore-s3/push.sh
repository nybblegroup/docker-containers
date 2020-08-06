#!/bin/bash
set -ex

docker build -t nybblegroup/mysql-restore-s3 .
docker push nybblegroup/mysql-restore-s3:latest
