function bd::util::find_used() {
  bd_used_cmds=()
  local bd_cmds=($(compgen -A function | grep bd::))
  bd_cmds+=(${BD_DEFAULT_EJECTED_FUNCTIONS[@]})
  bd::store::save bd_used_cmds bd_cmds
  bd::util::find_used_impl true
  bd::store::load bd_used_cmds
}

function bd::util::find_used_impl() {
  bd::store::load bd_cmds
  while read line
  do
    for cmd in "${bd_cmds[@]}"; do
      if $1; then
        local query=${cmd#bd::cmd::}
      else
        local query=$cmd
      fi
      if [[ "$line" == *"$query"* ]]; then
        bd::store::load bd_used_cmds
        if [[ "${bd_used_cmds[@]}" == *$cmd* ]]; then
          continue
        fi
        bd_used_cmds+=("$cmd")
        bd::store::save bd_used_cmds
        declare -f $cmd | sed -e 's/.*()//' | bd::util::find_used_impl false
      fi
    done
  done
}

function bd::eject() {
  local outfile=$1

  if [ -f "$outfile" ]; then
    bd::cmd::warn "The file $outfile already exists."
    bd::cmd::confirm "Overwrite?" || bd::cmd::error_exit "Aborted."

    bd::cmd::progress "Removing $outfile"
    rm $outfile
  fi

  bd::cmd::progress "Start ejecting \"$BD_SCRIPT\" into \"$outfile\""

  bd::util::find_used < $BD_SCRIPT

  echo "#!/usr/bin/env bash" >> $outfile
  echo "readonly BD_EJECTED=true" >> $outfile
  cat  $BD_ROOT/lib/global_variables.sh >> $outfile
  for cmd in "${bd_used_cmds[@]}"; do
    local definition=$(declare -f $cmd)
    echo "${definition//bd::cmd::/}" >> $outfile
  done

  bd::cmd::progress "Embed startup code"
  for cmd in "${BD_STARTUP_CODE[@]}"; do
    echo "$cmd" >> $outfile
  done

  cat $BD_SCRIPT >> $outfile
  bd::cmd::progress "Make output executable"
  chmod +x $outfile
  bd::cmd::progress "Done."
}
