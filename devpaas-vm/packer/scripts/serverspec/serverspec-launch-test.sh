#!/bin/bash -e

echo "***** Running Serverspec Tests *****"
<<<<<<< HEAD

sudo chown -R root:root /tmp/serverspec/

cd /tmp/serverspec

rake spec --trace
=======
cd /tmp/serverspec

rake spec
>>>>>>> Re-organize the server spec bash script file to modularise better
