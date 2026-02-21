#! /bin/bashDATA_DIR="/data"
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

# Check if there is a DNSMASQ cronjob file in /etc/cron.d/dnsmasq
if [ ! -f /etc/cron.d/dnsmasq ]; then
	echo "Creating the DNSMASQ cronjob file."
	cat <<EOF > /etc/cron.d/dnsmasq
# DNSMASQ cronjob to update DNS records
# Run every minute
* * * * * root $DATA_DIR/dnsmasq/update-dns.sh >/dev/null 2>&1
EOF
fi

# Run the scrip for the first time
"$DATA_DIR/dnsmasq/update-dns.sh"
