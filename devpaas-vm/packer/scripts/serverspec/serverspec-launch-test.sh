#!/bin/bash -e

echo "***** Changing permission to the serverspec files *****"
sudo chown -R root:root /tmp/serverspec/

echo "***** Waiting 30s for all services to startup before running the test *****"
sleep 30s

echo "***** Running Serverspec Tests *****"
cd /tmp/serverspec
rake spec --trace
