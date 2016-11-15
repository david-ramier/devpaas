#!/bin/bash -e
echo "***** Ruby installation *****"
sudo apt-get -y ruby

echo "***** Serverspec installation by gem *****"
sudo gem install serverspec

echo "***** Running Serverspec Tests *****"
cd /tmp/serverspec
mkdir /tmp/serverspec/spec/localhost

cp /tmp/tests/jenkins/serverspec-*.rb   /tmp/serverspec/spec/localhost/
cp /tmp/tests/nexus/serverspec-*.rb     /tmp/serverspec/spec/localhost/
cp /tmp/tests/sonarqube/serverspec-*.rb /tmp/serverspec/spec/localhost/

rake spec
