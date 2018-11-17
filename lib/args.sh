function bd::cmd::args() {
  local args_spec=$@

  declare -A types=(
   [string]=1  [number]=2  [bool]=3
  )

  declare -A opts

  local parsing=""

  opts["--help"]="bool"
  for OPT in $args_spec
  do
    read -r type default <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< $OPT)
    default=${default//\"/}

    if [ -n "$parsing" ]; then
      if [ "${types[$type]+isset}" ]; then
        opts[$parsing]=$OPT
        parsing=""
        case $type in
          'number' )
            if [[ -n $default ]] && [[ ! $default =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
              bd::logger::error_exit "args: parse failed; number is required as default value but got \"$default\""
            fi
            ;;
          'bool' )
            if [[ -n $default ]]; then
              bd::logger::error_exit "args: parse failed; default value in flag"
            fi
            ;;
        esac
      else
        bd::logger::error_exit "args: parse failed; unexpected non-type expression $OPT"
      fi
    else
      if [ "${types[$type]+isset}" ]; then
        bd::logger::error_exit "args: parse failed; unexpected type expression $OPT"
      fi
      if [[ $OPT != -* ]]; then
        bd::logger::error_exit "args: parse failed; option must be started with -"
      fi
      parsing=$OPT
    fi
  done

  declare -A already_got
  parsing=""
  for OPT in "${BD_ARGS[@]}"
  do
    if [ -n "$parsing" ]; then
      read -r type default <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$parsing]})

      case $type in
        'number' )
          if [[ ! $OPT =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
            bd::logger::error_exit "args: parse failed; number is required but got \"$OPT\""
          fi
          ;;
      esac

      eval "readonly arg_${parsing//-/}=$OPT"
      already_got[$parsing]=1
      parsing=""
    else
      if [ "${opts[$OPT]+isset}" ]; then
        if [ "${already_got[$OPT]+isset}" ]; then
          bd::logger::error_exit "args: parse failed; $OPT is already supplied"
        fi
        read -r type default <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$OPT]})

        if [[ $type == "bool" ]]; then
          eval "readonly arg_${OPT//-/}=true"
          already_got[$OPT]=1
          parsing=""
        else
          parsing=$OPT
        fi
      else
        if [[ $OPT != -* ]]; then
          bd::logger::error_exit "args: parse failed; unexpected expression $OPT"
        else
          bd::logger::error_exit "args: parse failed; unknown option $OPT"
        fi
      fi
    fi
  done

  for OPT in "${!opts[@]}"
  do
    if [ -z "${already_got[$OPT]+isset}" ]; then
      read -r type default_c <<< $(sed -e 's/:\(.*\)/ :"\1"/g' <<< ${opts[$OPT]})
      default_c=${default_c//\"/}

      case ${type} in
        'bool' )
          eval "readonly arg_${OPT//-/}=false"
          ;;
        * )
          if [ "$default_c" != ":*" -a "${arg_help:-false}" == "false" ]; then
            bd::logger::error_exit "args: parse failed; $OPT is required"
          fi
          eval "readonly arg_${OPT//-/}=${default_c##:}"
          ;;
      esac
    fi
  done

  if $arg_help; then
    echo "name: $BD_SCRIPT_NAME"
    echo -n "usage: $(basename $BD_SCRIPT) "
    for OPT in "${!opts[@]}"; do
      read -r type default <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$OPT]})
      case "${type}" in
        "bool" )
          printf "[%s] " "$OPT"
          ;;
        * )
          if [[ -z "$default" ]]; then
            printf "%s %s " "$OPT" "${type}"
          else
            printf "[%s %s%s] " "$OPT" "${type}" "(=${default//\"/})"
          fi
          ;;
      esac
    done
    printf "\n\n"
    while read line; do
      printf "\t%s\n" "$line"
    done <<< $BD_SCRIPT_DESCRIPTION
    exit 0
  fi
}
