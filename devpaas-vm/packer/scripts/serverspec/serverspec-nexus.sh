#!/bin/bash -e

echo "***** Running Serverspec Tests x Apache *****"

cp /tmp/nexus/tests/*.rb     /tmp/serverspec/spec/localhost/
