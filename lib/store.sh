function bd::store::save() {
  for key in $@; do
    if [[ "$(declare -p $key)" =~ "declare -a" ]]; then
      local value=$(eval "echo \"\${$key[@]}\"")
      local path=$BD_CACHE/$key.ary
    elif [ ! -v $key ]; then
      bd::logger::warn "saving variable \"$key\", which is not defined"
    else
      local value=$(eval "echo \"\$$key\"")
      local path=$BD_CACHE/$key
    fi
    echo "$value" > $path
  done
}

function bd::store::load() {
  for key in $@; do
    local path=$BD_CACHE/$key
    if [ -f $path.ary ]; then
      path=$path.ary
    elif [ ! -f $path ]; then
      bd::logger::warn "loading variable \"$key\", which is not defined"
    fi
    local value=$(cat $path)
    if [[ "$path" == *.ary ]]; then
      eval "$key=($value)"
    else
      eval "$key=\"$value\""
    fi
  done
}

BD_P_DEFAULT_EJECTED_FUNCTIONS+=("bd::store::save" "bd::store::load")
BD_P_STARTUP_CODE+=("bd::store::save bd_total_progress bd_current_progress")
