function name() {
  SCRIPT_NAME=$1
}

function description() {
  if [ -t 1 ]; then
    SCRIPT_DESCRIPTION=$(cat)
  else
    SCRIPT_DESCRIPTION=$@
  fi
}
