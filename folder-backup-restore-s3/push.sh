#!/bin/bash
set -ex

docker build -t nybblegroup/folder-backup-restore-s3 .
docker push nybblegroup/folder-backup-restore-s3:latest
