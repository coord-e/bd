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
    read -r type example <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< $OPT)
    example=${example//\"/}

    if [ -n "$parsing" ]; then
      if [ "${types[$type]+isset}" ]; then
        opts[$parsing]=$OPT
        parsing=""
        case $type in
          'number' )
            if [[ -n $example ]] && [[ ! $example =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
              bd::logger::error_exit "args: parse failed; number is required as example but got \"$example\""
            fi
            ;;
          'bool' )
            if [[ -n $example ]]; then
              bd::logger::error_exit "args: parse failed; example value in flag"
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
      read -r type example <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$parsing]})

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
        read -r type example <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$OPT]})

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
      read -r type example <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$OPT]})
      example=${example//\"/}

      case ${type} in
        'bool' )
          eval "readonly arg_${OPT//-/}=false"
          ;;
        * )
          eval "readonly arg_${OPT//-/}=$example"
          ;;
      esac
    fi
  done

  if $arg_help; then
    echo "name: $BD_SCRIPT_NAME"
    echo -n "usage: $(basename $BD_SCRIPT) "
    for OPT in "${!opts[@]}"; do
      read -r type example <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$OPT]})
      if [[ -z "$example" ]]; then
        example=""
      else
        example="(=${example//\"/})"
      fi

      printf "[%s %s%s] " "$OPT" "${type}" "${example}"
    done
    printf "\n\n"
    while read line; do
      printf "\t%s\n" "$line"
    done <<< $BD_SCRIPT_DESCRIPTION
    exit 0
  fi
}