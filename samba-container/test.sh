#!/bin/bash

mkdir /tmp/samba

samba --foreground  --no-process-group --debug-stdout &

if [ $? -ne 0 ]; then
    echo "Error while configuring samba service!"
    cat /var/log/samba/*.log
    exit 1
fi

apt-get install /packages/*.rpm

install-laps-v2-schema.py --domain "dc=domain,dc=alt"

