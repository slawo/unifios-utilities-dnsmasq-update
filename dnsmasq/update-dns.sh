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

lockfile="/var/run/lock/slawo-update-dns.lock"

(
if ! flock -n 100; then exit 1; fi

if [ -d /run/dnsmasq.dns.conf.d ]; then
	DNSMASQ_CONF_PATH="/run/dnsmasq.dns.conf.d"
	DNSMASQ_CONF_WAIT="$DNSMASQ_CONF_PATH/main.conf"
	DNSMASQ_CONF_TO_PATCH="$DNSMASQ_CONF_PATH/main.conf"
elif [ -d /run/dnsmasq.conf.d ]; then
	DNSMASQ_CONF_PATH="/run/dnsmasq.conf.d"
	DNSMASQ_CONF_WAIT="$DNSMASQ_CONF_PATH/shared.conf"
	DNSMASQ_CONF_TO_PATCH="$DNSMASQ_CONF_PATH/shared.custom.conf"
fi

DNSMASQ_CONF_PATCH_FOLDER="$DATA_DIR/dnsmasq/patch"

while [ ! -e "$DNSMASQ_CONF_WAIT" ]
do
	echo "Waiting for dnsmasq config to be created in $DNSMASQ_CONF_WAIT"
	sleep 3
done

NEED_UPDATE=false

filtered_patch=""
for file in $DNSMASQ_CONF_PATCH_FOLDER/shared*.conf; do
	[[ -f "$file" && -s "$file" ]] || continue
	while IFS= read -r line; do
		[[ -n "$line" ]] && filtered_patch+="$line"$'\n'
	done < "$file"
done

# Check if all non-empty lines in $DNSMASQ_CONF_PATCH_FILE exist in
# $DNSMASQ_CONF_TO_PATCH
while IFS= read -r line; do
	! grep -Fxq "$line" "$DNSMASQ_CONF_TO_PATCH" && NEED_UPDATE=true
done <<< "$filtered_patch"

if grep -Fxq "#start_patched" "$DNSMASQ_CONF_TO_PATCH" && grep -Fxq "#end_patched" "$DNSMASQ_CONF_TO_PATCH"; then
	echo `awk '/^#start_patched$/,/^#end_patched$/' "$DNSMASQ_CONF_TO_PATCH" `
	between_block=$(awk '/^#start_patched$/,/^#end_patched$/' "$DNSMASQ_CONF_TO_PATCH" | grep -v '^#start_patched$' | grep -v '^#end_patched$')
	# Check if any line in between_block is not in filtered_patch
	# If so, we need to update to remove the lines that are not longer needed.
	while IFS= read -r line; do
		[ -n "$line" ] && ! grep -Fxq "$line" <<< "$filtered_patch" && NEED_UPDATE=true
	done <<< "$between_block"
fi


# Final result
if $NEED_UPDATE; then
	echo "Update required."
	[[ $(tail -c1 "$DNSMASQ_CONF_TO_PATCH" | wc -l) -eq 0 ]] && echo "" >> "$DNSMASQ_CONF_TO_PATCH"
	grep -Fxq "#start_patched" "$DNSMASQ_CONF_TO_PATCH" || echo "#start_patched" >> "$DNSMASQ_CONF_TO_PATCH"
	grep -Fxq "#end_patched" "$DNSMASQ_CONF_TO_PATCH"   || echo "#end_patched" >> "$DNSMASQ_CONF_TO_PATCH"

	new_block=""
	while IFS= read -r line; do
		# Skip blank lines
		[[ -z "$line" ]] && continue

		if grep -Fxq "$line" "$DNSMASQ_CONF_TO_PATCH"; then
			# Line exists in the file so we need to include it ONLY if it is in
			# the between_block section so we do not remove it.
			if grep -Fxq "$line" <<< "$between_block"; then
				new_block+="$line"$'\n'
			fi
		else
			# Line is new (not in file1), include it
			new_block+="$line"$'\n'
		fi
	done <<< "$filtered_patch"

	output=""
	inside_block=false
	while IFS= read -r line; do
		if [[ "$line" == "#start_patched" ]]; then
			output+="$line"$'\n'
			inside_block=true
			output+="$new_block"
			continue
		elif [[ "$line" == "#end_patched" ]]; then
			inside_block=false
			output+="$line"$'\n'
			continue
		fi
		if ! $inside_block; then
			output+="$line"$'\n'
		fi
	done < "$DNSMASQ_CONF_TO_PATCH"

	#echo "output: $output"
	echo -n "$output" > "$DNSMASQ_CONF_TO_PATCH"

	service dnsmasq force-reload || kill $(ps -ef | awk '/dnsmas[q]/ {print $2}') || echo
else
	echo "No update needed."
fi
) 100>"$lockfile" || exit 1
