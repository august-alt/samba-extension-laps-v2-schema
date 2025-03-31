#!/bin/bash

chown -R builder2 /app/
cd /app/ && gear-rpm -ba

mkdir -p /app/packages

cp -r /home/builder2/RPM/RPMS/noarch/*.rpm /app/packages/