#!/bin/bash -e

echo "***** Running Serverspec Tests *****"

sudo chown -R root:root /tmp/serverspec/

cd /tmp/serverspec

sleep 30s

rake spec --trace
