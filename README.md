# unifios-utilities-dnsmasq-update

This is a script which updatates dnsmasq on unifi os with the values provided in the `shared.conf` file inside the `dnsmasq/patch` folder.

## Prereqisits

While this script can be run standalone, the default installer relies on [on-boot script](https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script) to keep it active after reboots and firmware updates. You should install on-boot script first.

## Installation

### Auto install

I provide an install script for a convenient one line installation:

```bash
curl -fsL "https://raw.githubusercontent.com/slawo/unifios-utilities-dnsmasq-update/HEAD/installer/remote-install.sh" | /bin/bash
```

### Manual install

To install the script simply copy `init-dnsmasq-update.sh` and `update-dns.sh` to your console's `/data/dnsmasq` folder and run `init-dnsmasq-update.sh`.

If you are using on-boot script then also add the `init-dnsmasq-update.sh` to the `on-boot.d` directory to ensure it will keep running despite reboots and firmware updates:

```bash
ln -sf "/data/dnsmasq/init-dnsmasq-update.sh" "/data/11-init-dnsmasq-updates.sh"
```

## Setup

In order to patch the dnsmasq configuration on your unifi router you need to provide a file in `/data/dnsmasq/patch/shared.conf`.

For example:

```dnsmasq
host-record=unifi.koln.example.com,192.168.20.1
host-record=unifi.paris.example.com,192.168.90.1
server=/*.koln.example.com/192.168.20.1
server=/*.paris.example.com/192.168.90.1
```

You can also provide additional files as long as they start with `shared` and end with `.conf`, for example `/data/dnsmasq/patch/shared-tailscale.conf`:

```dnsmasq
interface=tailscale*
```
