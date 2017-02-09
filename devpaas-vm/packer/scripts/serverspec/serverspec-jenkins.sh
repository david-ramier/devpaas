#!/bin/bash -e

echo "***** Running Serverspec Tests x Apache *****"

cp /tmp/jenkins/tests/*.rb   /tmp/serverspec/spec/localhost/
