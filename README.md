# Observe Linux Host Monitoring install scripts

This repo contains unofficial and unsupported scripts for installing and configuring Observe Linux Host monitoring agents.

Currently the scripts only work on Ubuntu 20.04 on bare metal and non-AWS VMs (i.e. in KVM). For up-to-date instructions on other
operating systems, please refer to [official documentation](https://docs.observeinc.com/en/latest/content/data-ingestion/integrations/linux.html).

To get an overview of what final result would look like, please see [announcement blog article](https://www.observeinc.com/blog/integrations-linux-host-monitoring/).

## Instructions

Clone this repo

```sh
git clone https://github.com/rustomax/lhm-scripts.git
```

Create variables file `vars.sh` and populate it with relevant info, replacing placeholders with correct values
Datacenter can be any arbitrary string. It provides a way to group various hosts together into logical or geographic entities.

```sh
#!/bin/bash

export OBSERVE_CUSTOMER=<YOUR_CUSTOMER_ID>
export OBSERVE_TOKEN=<YOUR_OBSERVE_TOKEN>
export OBSERVE_DATACENTER=<DATACENTER>
```

Make the script executable

```sh
chmod 755 vars.sh
```

Install agents

```sh
cd ubuntu-20.04
./install-osquery.sh
./install-fluentbit.sh
./install-telegraph.sh
```
