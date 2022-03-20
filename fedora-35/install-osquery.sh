#!/bin/bash

set -e

source ../vars.sh

# Check if we are running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root (or sudo)" 1>&2
   exit 1
fi

# Add OSQuery yum repo
yum install -y yum-utils
curl -L https://pkg.osquery.io/rpm/GPG | tee /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery
yum-config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
yum-config-manager --enable osquery-s3-rpm-repo

# Install OSQuery
yum install -y osquery

# Create OSQuery config files
cp ../configs/osquery.conf /etc/osquery/
cp ../configs/osquery.flags /etc/osquery/

# Start the osqueryd service and check on its status
systemctl enable osqueryd
systemctl restart osqueryd
echo "Sleeping for 5 sec to allow osqueryd service to start"
sleep 5
systemctl status osqueryd --no-pager
