readonly BD_CACHE="$HOME/.cache/bd"

if [ ! -d "$BD_CACHE" ]; then
  mkdir $BD_CACHE
fi

if [ -v BD_EJECTED ]; then
  BD_SCRIPT=$0
else
  BD_SCRIPT=$1
  shift
fi

BD_ARGS=($@)
BD_SCRIPT_NAME=$BD_SCRIPT

