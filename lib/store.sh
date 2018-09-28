function _save() {
  for key in $@; do
    if [ ! -v $key ]; then
      warn "internal; saving variable \"$key\", which is not defined"
    fi
    value=$(eval "echo \$$key")
    echo $value > $BD_CACHE/$key
  done
}

function _load() {
  for key in $@; do
    local path=$BD_CACHE/$key
    if [ ! -f $path ]; then
      warn "internal; loading variable \"$key\", which is not defined"
    fi
    value=$(cat $path)
    eval "$key=$value"
  done
}
