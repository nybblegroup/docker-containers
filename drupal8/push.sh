#!/bin/bash
set -ex

docker build -t nybblegroup/drupal8 .
docker push nybblegroup/drupal8:latest
