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
      if [[ -n "${types[$type]}" ]]; then
        opts[$parsing]=$OPT
        parsing=""
        case $type in
          'number' )
            if [[ -n $example ]] && [[ ! $example =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
              bd::cmd::error "arg: parse failed; number is required as example but got \"$example\""
              exit -1
            fi
            ;;
          'bool' )
            if [[ -n $example ]]; then
              bd::cmd::error "arg: parse failed; example value in flag"
              exit -1
            fi
            ;;
        esac
      else
        bd::cmd::error "arg: parse failed; unexpected non-type expression $OPT"
        exit -1
      fi
    else
      if [[ -n "${types[$type]}" ]]; then
        bd::cmd::error "arg: parse failed; unexpected type expression $OPT"
        exit -1
      fi
      if [[ $OPT != -* ]]; then
        bd::cmd::error "arg: parse failed; option must be started with -"
        exit -1
      fi
      parsing=$OPT
    fi
  done

  declare -A already_got
  parsing=""
  for OPT in $ARGS
  do
    if [ -n "$parsing" ]; then
      read -r type example <<< $(sed -e 's/:\(.*\)/ "\1"/g' <<< ${opts[$parsing]})

      case $type in
        'number' )
          if [[ ! $OPT =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
            bd::cmd::error "arg: parse failed; number is required but got \"$OPT\""
            exit -1
          fi
          ;;
      esac

      eval "readonly arg_${parsing//-/}=$OPT"
      already_got[$parsing]=1
      parsing=""
    else
      if [[ -n "${opts[$OPT]}" ]]; then
        if [[ -n "${already_got[$OPT]}" ]]; then
          bd::cmd::error "arg: parse failed; $OPT is already supplied"
          exit -1
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
          bd::cmd::error "arg: parse failed; unexpected expression $OPT"
          exit -1
        else
          bd::cmd::error "arg: parse failed; unknown option $OPT"
          exit -1
        fi
      fi
    fi
  done

  for OPT in "${!opts[@]}"
  do
    if [[ -z "${already_got[$OPT]}" ]]; then
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
    echo -n "usage: $SCRIPT_NAME "
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
    done <<< $SCRIPT_DESCRIPTION
    exit 0
  fi
}
