function bd::run() {
  local script=$1

  for name in $(compgen -A function); do
    if [[ "$name" == bd::cmd::* ]]; then
      local definition=$(declare -f $name)
      eval "${definition#bd::cmd::}"
    fi
  done

  source $script
}

function bd::run_startup() {
  for cmd in "${BD_STARTUP_CODE[@]}"; do
    eval "$cmd"
  done
}
