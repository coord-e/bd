function bd::emit_uninstaller() {
  local outfile=${1/-//dev/stdout}

  cat << EOF > "$outfile"
rm -rf "$BD_ROOT"
rm -r "$BD_CACHE"
EOF
}

