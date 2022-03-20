#!/bin/bash

set -e

source ../vars.sh

# Check if we are running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root (or sudo)" 1>&2
   exit 1
fi

# Add fluentbit yum repository (custom package)
sudo tee /etc/yum.repos.d/fluent-bit.repo > /dev/null <<EOT
[fluent-bit]
name=fluent-bit
baseurl=https://shogo82148-rpm-repository.s3-ap-northeast-1.amazonaws.com/amazonlinux/2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://shogo82148-rpm-repository.s3-ap-northeast-1.amazonaws.com/RPM-GPG-KEY-shogo82148
EOT

# Install the fluentbit agent
yum install -y fluent-bit-1.8.1-2.amzn2.x86_64

# We need to lock the package to the installed version
# as later versions require newer libc & libssl, which we don't have
yum versionlock fluent-bit-*

# Create fluentbit config file
HOSTNAME=$(hostname)
CONFIG=/etc/fluent-bit/fluent-bit.conf
cp ../configs/td-agent-bit.conf $CONFIG
sed -i "s/OBSERVE_HOST/${HOSTNAME}/g" $CONFIG
sed -i "s/OBSERVE_DATACENTER/${OBSERVE_DATACENTER}/g" $CONFIG
sed -i "s/OBSERVE_CUSTOMER/${OBSERVE_CUSTOMER}/g" $CONFIG
sed -i "s/OBSERVE_TOKEN/${OBSERVE_TOKEN}/g" $CONFIG

# Start the fluent-bit service and check on its status
systemctl restart fluent-bit
echo "Sleeping for 5 sec to allow osqueryd service to start"
sleep 5
systemctl status fluent-bit --no-pager

