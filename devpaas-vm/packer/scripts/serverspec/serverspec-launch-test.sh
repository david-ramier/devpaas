#!/bin/bash -e

echo "***** Running Serverspec Tests *****"
cd /tmp/serverspec

rake spec
