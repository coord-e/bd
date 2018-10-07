#!/usr/bin/env bash

set -eu

SCRIPT_URL="https://coord-e.github.io/bd/install.sh"

TMP_EXEC_PATH="$(mktemp)"

echo "Downloading installer"

curl -fsSL ${SCRIPT_URL} > "${TMP_EXEC_PATH}"
chmod +x "${TMP_EXEC_PATH}"
"${TMP_EXEC_PATH}" < /dev/tty
