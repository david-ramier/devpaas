#!/bin/bash -e

echo "***** Running Serverspec Tests x Apache *****"

cp /tmp/sonarqube/tests/*.rb /tmp/serverspec/spec/localhost/