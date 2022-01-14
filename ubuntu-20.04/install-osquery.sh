#!/bin/bash

set -e

source ../vars.sh

# Check if we are running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root (or sudo)" 1>&2
   exit 1
fi

# Add OSQuery apt repo
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
if ! grep -Fq https://pkg.osquery.io/deb /etc/apt/sources.list.d/osquery.list
then
  tee -a /etc/apt/sources.list.d/osquery.list > /dev/null <<EOT
deb [arch=amd64] https://pkg.osquery.io/deb deb main
EOT
fi

# Install OSQuery
apt-get update
apt-get install -y osquery

# Copy OSQuery config file
cp ../configs/osquery.conf /etc/osquery/

# Start the osqueryd service
systemctl restart osqueryd
systemctl status osqueryd
