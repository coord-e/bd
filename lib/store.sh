function _save() {
  key=$1
  value=$(eval "echo \$$key")
  echo $value > $BD_CACHE/$key
}

function _load() {
  key=$1
  value=$(cat $BD_CACHE/$key)
  eval "$key=$value"
}
