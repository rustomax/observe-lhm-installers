#!/bin/bash

set -e

source ../vars.sh

# Check if we are running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root (or sudo)" 1>&2
   exit 1
fi

# Add telegraph apt repository
wget -qO- https://repos.influxdata.com/influxdb.key | apt-key add -
source /etc/lsb-release
if ! grep -Fq https://repos.influxdata.com/${DISTRIB_ID,,} /etc/apt/sources.list.d/influxdb.list
then
  tee -a /etc/apt/sources.list.d/influxdb.list > /dev/null <<EOT
deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable
EOT
fi

# Install telegraph
apt-get update
apt-get install -y telegraf

# Create telegraph config file
HOSTNAME=$(hostname)
CONFIG=/etc/telegraf/telegraf.conf
cp ../configs/telegraf.conf $CONFIG
sed -i "s/OBSERVE_HOST/${HOSTNAME}/g" $CONFIG
sed -i "s/OBSERVE_DATACENTER/${OBSERVE_DATACENTER}/g" $CONFIG
sed -i "s/OBSERVE_CUSTOMER/${OBSERVE_CUSTOMER}/g" $CONFIG
sed -i "s/OBSERVE_TOKEN/${OBSERVE_TOKEN}/g" $CONFIG

systemctl restart telegraf
systemctl status telegraf
