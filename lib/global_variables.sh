readonly BD_CACHE="$HOME/.cache/bd"

if [ ! -d "$BD_CACHE" ]; then
  mkdir -p $BD_CACHE
fi

if [ -v BD_EJECTED ]; then
  BD_SCRIPT=$0
else
  BD_SCRIPT=$1
  shift
fi

BD_ARGS=($@)
BD_SCRIPT_NAME=$BD_SCRIPT

bd_total_progress=0
bd_current_progress=0

BD_DEFAULT_EJECTED_FUNCTIONS=()

BD_LOG_LEVEL=${BD_LOG_LEVEL:-info}
