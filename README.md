# Observe Linux Host Monitoring install scripts

This repo contains unofficial and unsupported scripts for installing and configuring Observe Linux Host monitoring agents.

Currently the scripts are provided for Ubuntu 20.04 and Fedora 35 on bare metal and non-AWS VMs (i.e. in KVM). For up-to-date instructions on other
operating systems, please refer to [official documentation](https://docs.observeinc.com/en/latest/content/data-ingestion/integrations/linux.html).

To get an overview of what final result would look like, please see [announcement blog article](https://www.observeinc.com/blog/integrations-linux-host-monitoring/).

## Instructions

Clone this repo

```sh
git clone https://github.com/rustomax/observe-lhm-installers.git
cd observe-lhm-installers
```

Create variables file `vars.sh` with the following content, replacing placeholders with correct values.
Datacenter can be any arbitrary string. It provides a way to logically group various hosts together.

```sh
export OBSERVE_CUSTOMER=<YOUR_CUSTOMER_ID>
export OBSERVE_TOKEN=<YOUR_OBSERVE_TOKEN>
export OBSERVE_DATACENTER=<DATACENTER>
```

Install agents

```sh
cd ubuntu-20.04
sudo ./install-osquery.sh
sudo ./install-fluentbit.sh
sudo ./install-telegraf.sh
```

## Known issues

### Getting `gpg: keyserver receive failed: No such file or directory` error message during osquery install

Make sure you have resolver running on the host, i.e.

```sh
sudo systemctl start systemd-resolved.service
```
