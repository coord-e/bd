function _save() {
  for key in $@; do
    value=$(eval "echo \$$key")
    echo $value > $BD_CACHE/$key
  done
}

function _load() {
  for key in $@; do
    value=$(cat $BD_CACHE/$key)
    eval "$key=$value"
  done
}
