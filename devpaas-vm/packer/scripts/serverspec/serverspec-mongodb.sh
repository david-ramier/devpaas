#!/bin/bash -e

echo "***** Running Serverspec Tests x mongodb *****"

cp /tmp/mongodb/tests/*.rb   /tmp/serverspec/spec/localhost/

