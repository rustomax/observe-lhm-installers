#!/bin/bash

set -e

source ../vars.sh

# Check if we are running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root (or sudo)" 1>&2
   exit 1
fi

# Add telegraph yum repository (RHEL 7)
sudo tee /etc/yum.repos.d/influxdb.repo > /dev/null <<EOT
[influxdb]
name = InfluxDB Repository - RHEL
baseurl = https://repos.influxdata.com/rhel/7/x86_64/stable/
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdb.key
EOT

# Install telegraf package
yum install telegraf -y

# Create telegraph config file
HOSTNAME=$(hostname)
CONFIG=/etc/telegraf/telegraf.conf
cp ../configs/telegraf.conf $CONFIG
sed -i "s/OBSERVE_HOST/${HOSTNAME}/g" $CONFIG
sed -i "s/OBSERVE_DATACENTER/${OBSERVE_DATACENTER}/g" $CONFIG
sed -i "s/OBSERVE_CUSTOMER/${OBSERVE_CUSTOMER}/g" $CONFIG
sed -i "s/OBSERVE_TOKEN/${OBSERVE_TOKEN}/g" $CONFIG

# Start the osqueryd service and check on its status
systemctl restart telegraf
echo "Sleeping for 5 sec to allow telegraf service to start"
sleep 5
systemctl status telegraf --no-pager
