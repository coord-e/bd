outfile=${ARGS[0]}
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
