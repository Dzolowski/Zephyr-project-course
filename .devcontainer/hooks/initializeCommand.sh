#!/bin/bash
set -euo pipefail

echo "0 - [initialize] This runs once before docker build."

# echo "[*] Current user: $(whoami)"
# echo "[*] UID: $(id -u)"
# echo "[*] Groups: $(id -Gn)"
# echo "[*] Sudo available: $(if sudo -n true 2>/dev/null; then echo YES; else echo NO; fi)"

UDEV_RULES_FILE="/etc/udev/rules.d/60-openocd.rules"
if [ ! -f "$UDEV_RULES_FILE" ]; then
    echo "[⚠] pyOCD udev rules not found on host: $UDEV_RULES_FILE"
    echo "    To fix this, run on your host:"
    echo "    sudo curl -sSL https://raw.githubusercontent.com/openocd-org/openocd/master/contrib/60-openocd.rules -o $UDEV_RULES_FILE"
    echo "    sudo udevadm control --reload-rules && sudo udevadm trigger"
else
    echo "[✓] found $UDEV_RULES_FILE"
fi

# Prepare needed mount directories
mounts=("$HOME/.local/share/cmsis-pack-manager" "$HOME/.cache/pip")
echo "Creating mount directories ..."
mkdir -p "${mounts[@]}"
