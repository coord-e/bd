outfile=${ARGS[0]}

if [ -f "$outfile" ]; then
  warn "The file $outfile already exists."
  confirm "Overwrite?"
  if [ "$?" != "0" ]; then
    error "Aborted."
    exit -1
  fi

  progress "Removing $outfile"
  rm $outfile
fi

function eject() {
  progress "Start ejecting \"$SCRIPT\" into \"$outfile\""

  while read line
  do
    if [[ $line == bd_import* ]]; then
      local cmdline=($line)
      local importing="$(eval "echo ${cmdline[1]}")"
      cat "$importing" >> $outfile
      progress "Importing $importing"
    else
      echo "$line" >> $outfile
    fi
  done < $BD_BIN
  progress "Done."
}

eject
exit
