#!/bin/bash
set -euo pipefail

echo "3 - [postCreate] Workspace is mounted. You can install project dependencies now."

# echo "[*] Current user: $(whoami)"
# echo "[*] UID: $(id -u)"
# echo "[*] Groups: $(id -Gn)"
# echo "[*] Sudo available: $(if sudo -n true 2>/dev/null; then echo YES; else echo NO; fi)"

### see docs/how-to-pre-commit.md
if [[ -f .git ]]; then
    echo ".git is a file, we are probably in Git Worktree - not installing pre-commit"
else
    pre-commit install
fi
