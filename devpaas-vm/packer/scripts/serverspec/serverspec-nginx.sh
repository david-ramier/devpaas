#!/bin/bash -e

echo "***** Running Serverspec Tests x NGINX *****"

cp /tmp/nginx/tests/*.rb   /tmp/serverspec/spec/localhost/

