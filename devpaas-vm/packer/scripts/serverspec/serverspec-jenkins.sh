#!/bin/bash -e

echo "***** Copying Serverspec Tests x Jenkins *****"

cp /tmp/jenkins/tests/*.rb   /tmp/serverspec/spec/localhost/
