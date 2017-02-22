#!/bin/bash -e

echo "***** Running Serverspec Tests *****"

sudo chown -R root:root /tmp/serverspec/

cd /tmp/serverspec

sleep 10s

rake spec --trace
