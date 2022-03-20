#!/bin/bash

set -e

source ../vars.sh

# Check if we are running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root (or sudo)" 1>&2
   exit 1
fi

# Add fluentbit apt repository
wget -qO - https://packages.fluentbit.io/fluentbit.key | apt-key add -
source /etc/lsb-release

if ! grep -Fq https://packages.fluentbit.io/${DISTRIB_ID,,} /etc/apt/sources.list.d/fluentbit.list
then
  tee -a /etc/apt/sources.list.d/fluentbit.list > /dev/null <<EOT
deb https://packages.fluentbit.io/${DISTRIB_ID,,}/${DISTRIB_CODENAME} ${DISTRIB_CODENAME} main
EOT
fi

# Install fluentbit agent
apt-get update
apt-get install -y td-agent-bit

# Create fluentbit config file
HOSTNAME=$(hostname)
CONFIG=/etc/td-agent-bit/td-agent-bit.conf
cp ../configs/td-agent-bit.conf $CONFIG
sed -i "s/OBSERVE_HOST/${HOSTNAME}/g" $CONFIG
sed -i "s/OBSERVE_DATACENTER/${OBSERVE_DATACENTER}/g" $CONFIG
sed -i "s/OBSERVE_CUSTOMER/${OBSERVE_CUSTOMER}/g" $CONFIG
sed -i "s/OBSERVE_TOKEN/${OBSERVE_TOKEN}/g" $CONFIG

# Start the fluent-bit service and check on its status
systemctl restart td-agent-bit
echo "Sleeping for 5 sec to allow fluent-bit service to start"
sleep 5
systemctl status td-agent-bit --no-pager
