#!/bin/bash
set -ex

docker build -t nybblegroup/mysql-backup-s3 .
docker push nybblegroup/mysql-backup-s3:latest
