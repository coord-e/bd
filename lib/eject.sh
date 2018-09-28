outfile=${BD_ARGS[0]}

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

function bd::eject() {
  bd::cmd::progress "Start ejecting \"$BD_SCRIPT\" into \"$outfile\""

  echo "#!/usr/bin/env bash" >> $outfile
  echo "readonly BD_EJECTED=true" >> $outfile
  while read line
  do
    if [[ "$line" == bd_import* ]]; then
      local cmdline=($line)
      local importing="$(eval "echo ${cmdline[1]}")"
      cat "$importing" >> $outfile
      bd::cmd::progress "Importing $importing"
    else
      echo "$line" >> $outfile
    fi
  done < $BD_BIN
  bd::cmd::progress "Make output executable"
  chmod +x $outfile
  bd::cmd::progress "Done."
}

bd::eject
exit
