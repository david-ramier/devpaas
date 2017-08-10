#!/bin/bash
set -e

DOMAIN_NAME="${domain_name}"
VM_NAME="${vm_name}"

echo "Changing the search domain in /etc/resolv.conf file"
/bin/sed -i "s/search.*/search $DOMAIN_NAME/g" /etc/resolv.conf

echo "Changing the hostname in /etc/hosts file ..."
/bin/sed -i "s/localhost/$VM_NAME/g" /etc/hosts

echo "Retrieving the current hostname ..."
export AWS_HOSTNAME=$(hostname)

echo "Changing the aws hostname ($AWS_HOSTNAME) with target hostname ($VM_NAME) in /etc/hostname file ..."
/bin/sed -i "s/$AWS_HOSTNAME/$VM_NAME/g" /etc/hostname

/bin/hostname $VM_NAME