function bd::cmd::confirm (){
  local MSG=$1
  while true; do
    printf '%s ' "$MSG"
    printf "[y/n] > "
    read input
    if [ "$input" = "y" ]; then
      return 0;
    elif [ "$input" = "n" ]; then
      return 1;
    fi
  done
}
