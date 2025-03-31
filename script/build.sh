#!/bin/bash

git config --global --add safe.directory /app

cd /app/ && gear-rpm -ba

mkdir -p /app/packages

cp -r /home/builder/RPM/RPMS/noarch/*.rpm /app/packages/