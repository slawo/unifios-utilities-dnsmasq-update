#!/bin/bash
case "$(ubnt-device-info firmware || true)" in
1*)
	DATA_DIR="/mnt/data"
	;;
2* | 3* | 4* | 5*)
	DATA_DIR="/data"
	;;
*)
	if [ -d /data ]; then
		DATA_DIR="/data"
	else
		echo "ERROR: No persistent storage found." 1>&2
		exit 1
	fi
	;;
esac

UPDATE=false

usage() {
	echo "Usage: remote-install.sh [--update]"
}

while [ "$#" -gt 0 ]; do
	case "$1" in
	-u | --update)
		UPDATE=true
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "ERROR: Unknown option: $1" 1>&2
		usage 1>&2
		exit 1
		;;
	esac
	shift
done

# array of files to download
FILES=(
	"dnsmasq/init-dnsmasq-update.sh"
	"dnsmasq/update-dns.sh"
)

INSTALL_EXISTS=false
for file in "${FILES[@]}"; do
	if [ -e "$DATA_DIR/$file" ]; then
		INSTALL_EXISTS=true
		break
	fi
done

if $INSTALL_EXISTS && ! $UPDATE; then
	echo "ERROR: dnsmasq update scripts are already installed in $DATA_DIR/dnsmasq." 1>&2
	echo "Run with --update to upgrade the existing installation." 1>&2
	exit 1
fi

mkdir -p "$DATA_DIR/dnsmasq"
mkdir -p "$DATA_DIR/dnsmasq/patch"

if $UPDATE; then
	echo "Updating dnsmasq update scripts in $DATA_DIR/dnsmasq."
else
	echo "Installing dnsmasq update scripts in $DATA_DIR/dnsmasq."
fi

# download each file
for file in "${FILES[@]}"; do
	curl -fsSL "https://raw.githubusercontent.com/slawo/unifios-utilities-dnsmasq-update/HEAD/$file" -o "$DATA_DIR/$file"
	if [[ "$file" == *.sh ]]; then
		chmod +x "$DATA_DIR/$file"
	fi
done

ONBOOT_PATH="$DATA_DIR/on_boot.d"
#check if the onboot directory exists
if [ -d "$ONBOOT_PATH" ]; then
	ln -sf "$DATA_DIR/dnsmasq/init-dnsmasq-update.sh" "$ONBOOT_PATH/11-init-dnsmasq-updates.sh"
fi

echo "Starting init"
. "$DATA_DIR/dnsmasq/init-dnsmasq-update.sh"

if [ ! -d "$ONBOOT_PATH" ]; then
	echo "You need to install the onboot script to ensure this script continues working after reboots."
	echo "Please see https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script."
	echo ""
	echo "once installed you will need to add init-dnsmasq-update.sh to the onboot directory."
	echo "You can do this by running the following command:"
	echo "ln -sf $DATA_DIR/dnsmasq/init-dnsmasq-update.sh $ONBOOT_PATH/11-init-dnsmasq-updates.sh"
	echo ""
	echo "Alternatively, you can run the following command to install the init script:"
	echo "curl -fsL \"https://raw.githubusercontent.com/slawo/unifios-utilities-dnsmasq-update/HEAD/remote-install.sh\" | /bin/bash"
fi
