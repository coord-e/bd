bd_used_cmds=()

function bd::util::find_used() {
  local bd_cmds=($(compgen -A function | grep bd::cmd::))
  while read line
  do
    for cmd in "${bd_cmds[@]}"; do
      if $1; then
        local query=${cmd#bd::cmd::}
      else
        local query=$cmd
      fi
      if [[ "$line" == *"$query"* ]]; then
        bd_used_cmds+=("$cmd")
        declare -f $cmd | sed -e 's/.*()//' | bd::util::find_used false
      fi
    done
  done
}

function bd::eject() {
  local outfile=$1

  if [ -f "$outfile" ]; then
    bd::cmd::warn "The file $outfile already exists."
    bd::cmd::confirm "Overwrite?"
    if [ "$?" != "0" ]; then
      bd::cmd::error "Aborted."
      exit -1
    fi

    bd::cmd::progress "Removing $outfile"
    rm $outfile
  fi

  bd::cmd::progress "Start ejecting \"$BD_SCRIPT\" into \"$outfile\""

  bd_used_cmds=()
  bd::util::find_used true < $BD_SCRIPT

  echo "#!/usr/bin/env bash" >> $outfile
  echo "readonly BD_EJECTED=true" >> $outfile
  cat  $BD_ROOT/lib/global_variables.sh >> $outfile
  for cmd in "${bd_used_cmds[@]}"; do
    local definition=$(declare -f $cmd)
    echo "${definition//bd::cmd::/}" >> $outfile
  done

  cat $BD_SCRIPT >> $outfile
  bd::cmd::progress "Make output executable"
  chmod +x $outfile
  bd::cmd::progress "Done."
}
