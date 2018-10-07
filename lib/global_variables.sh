readonly BD_CACHE="$HOME/.cache/bd"

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

# BD_P_ variables are set before startup, and they're immutable after setup
BD_P_DEFAULT_EJECTED_FUNCTIONS=()

# Startup code always have to return 0
BD_P_STARTUP_CODE=("[ ! -d $BD_CACHE ] && mkdir -p $BD_CACHE || :")

BD_LOG_LEVEL=${BD_LOG_LEVEL:-info}
