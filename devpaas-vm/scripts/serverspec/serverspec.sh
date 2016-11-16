#!/bin/bash -e
echo "***** Ruby installation *****"
sudo apt-get -y install ruby

echo "***** Serverspec installation by gem *****"
sudo gem install serverspec

echo "***** Running Serverspec Tests *****"
cd /tmp/serverspec
if [ ! -d "/tmp/serverspec/spec/localhost" ]; then
  mkdir /tmp/serverspec/spec/localhost
fi

cp /tmp/jenkins/tests/*.rb   /tmp/serverspec/spec/localhost/
cp /tmp/nexus/tests/*.rb     /tmp/serverspec/spec/localhost/
cp /tmp/sonarqube/tests/*.rb /tmp/serverspec/spec/localhost/

rake spec
