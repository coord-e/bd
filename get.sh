#!/usr/bin/env bash

SCRIPT_URL="https://coord-e.github.io/bd/install.sh"

TMP_EXEC_PATH="$(mktemp)" || exit
curl -fsSL ${SCRIPT_URL} > "${TMP_EXEC_PATH}" || exit
chmod +x "${TMP_EXEC_PATH}"
"${TMP_EXEC_PATH}" < /dev/tty
