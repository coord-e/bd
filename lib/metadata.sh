function bd::cmd::name() {
  BD_SCRIPT_NAME=$1
}

function bd::cmd::description() {
  if [ -t 1 ]; then
    BD_SCRIPT_DESCRIPTION=$(cat)
  else
    BD_SCRIPT_DESCRIPTION=$@
  fi
}
