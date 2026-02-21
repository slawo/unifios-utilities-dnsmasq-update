#!/usr/bin/env bash
DATA_DIR="/data"
case "$(ubnt-device-info firmware || true)" in
1*)
	DATA_DIR="/mnt/data"
	;;
2* | 3* | 4* | 5*)
	DATA_DIR="/data"
	;;
*)
	echo "ERROR: No persistent storage found." 1>&2
	exit 1
	;;
esac


mkdir -p "$DATA_DIR/dnsmasq"
mkdir -p "$DATA_DIR/dnsmasq/patch"
# array of files to download
FILES=(
	"dnsmasq/init-dnsmasq-update.sh"
	"dnsmasq/update-dns.sh"
)
# download each file
for file in "${FILES[@]}"; do
	curl "https://raw.githubusercontent.com/slawo/unifios-utilities-dnsmasq-update/HEAD/$file" >"/$DATA_DIR/$file"
	if [[ "$file" == *.sh ]]; then
		chmod +x "/$DATA_DIR/$file"
	fi
done

ONBOOOT_PATH="$DATA_DIR/on_boot.d"
#check if the onboot directory exists
if [ -d "$ONBOOOT_PATH" ]; then
	ln -sf "$DATA_DIR/dnsmasq/init-dnsmasq-update.sh" "$ONBOOOT_PATH/11-init-dnsmasq-updates.sh"
fi

echo "Starting init"
. $DATA_DIR/dnsmasq/init-dnsmasq-update.sh

if [ ! -d "$ONBOOOT_PATH" ]; then
	echo "You need to install the onboot script to ensure this script continues working after reboots."
	echo "Please see https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script."
	echo ""
	echo "once installed you will need to add init-dnsmasq-update.sh to the onboot directory."
	echo "You can do this by running the following command:"
	echo "ln -sf $DATA_DIR/dnsmasq/init-dnsmasq-update.sh $ONBOOOT_PATH/11-init-dnsmasq-updates.sh"
	echo ""
	echo "Alternatively, you can run the following command to install the init script:"
	echo "curl -fsL \"https://raw.githubusercontent.com/slawo/unifios-utilities-dnsmasq-update/HEAD/remote-install.sh\" | /bin/bash"
fi