#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### Installing post-create script
POST_CREATE_FEATURE_INSTALL_SCRIPT_PATH="/usr/local/share/devcontainer_features.d/feature-postCreate-pyocd.sh"
POST_CREATE_FEATURE_INSTALL_DIR="$(dirname "$POST_CREATE_FEATURE_INSTALL_SCRIPT_PATH")"
POST_CREATE_FEATURE_INSTALL_PARAMS_PATH="$POST_CREATE_FEATURE_INSTALL_DIR/feature-postCreate-pyocd.param"
POST_CREATE_FEATURE_SCRIPT="$(basename "$POST_CREATE_FEATURE_INSTALL_SCRIPT_PATH")"

mkdir -p "$POST_CREATE_FEATURE_INSTALL_DIR"
cp "$SCRIPT_DIR/$POST_CREATE_FEATURE_SCRIPT" "$POST_CREATE_FEATURE_INSTALL_SCRIPT_PATH"
chmod +x "$POST_CREATE_FEATURE_INSTALL_SCRIPT_PATH"

### save parameters
echo "MCUPACKAGES=\"${MCUPACKAGES}\"" > "$POST_CREATE_FEATURE_INSTALL_PARAMS_PATH"
chmod 644 "$POST_CREATE_FEATURE_INSTALL_PARAMS_PATH"

echo "pyOCD installation will be continued in postCreate phase"
