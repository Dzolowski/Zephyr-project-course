#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
### Load parameters
source "$SCRIPT_DIR/feature-postCreate-pyocd.param"

pip install --break-system-packages --user pyocd
# Temporarily add this to PATH, it get's added later
export PATH="$HOME/.local/bin:$PATH"

download=${DEVCONTAINER_PYOCD_DOWNLOAD_PACKAGES:-1}
echo "DEVCONTAINER_PYOCD_DOWNLOAD_PACKAGES=${download}"

if [ ${download} = 0 ]; then
    echo "Not installing pyOCD packages"
else
    pyocd pack show

    ### Parse and install additional MCU support packages
    ### packs can be found at: ~/.local/share/cmsis-pack-manager
    if [ -n "$MCUPACKAGES" ]; then
        IFS=',' read -ra PACKAGES <<<"$MCUPACKAGES"
        for package in "${PACKAGES[@]}"; do
            echo "Installing pyOCD package: ${package}"
            pyocd pack install ${package}
        done
    fi
fi
