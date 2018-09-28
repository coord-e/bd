function run() {
  local script=$1

  for name in $(compgen -A function); do
    if [[ "$name" == bd::cmd::* ]]; then
      local definition=$(declare -f $name)
      eval "${definition#bd::cmd::}"
    fi
  done

  source $script
}
