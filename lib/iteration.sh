function bd::cmd::iter() {
  local iterations=$(eval "echo $@")
  local iterations=$(eval "echo $@")
  total_progress=$(wc -w <<< $iterations)
  current_progress=0
  bd::store::save total_progress current_progress
  echo $iterations
}

function bd::cmd::range() {
  local start=0
  local end=0
  case "$#" in
    "1")
      end=$1
      ;;
    "2")
      start=$1
      end=$2
      ;;
  esac
  bd::cmd::iter {$start..$end}
}

function bd::cmd::progress() {
  bd::store::load current_progress total_progress
  current_progress=$((current_progress += 1))
  if [[ "$total_progress" == "0" ]]; then
    local status="$(printf "%3d" $current_progress)."
  else
    local percentage=$(( current_progress * 100 / total_progress ))
    local status="$(printf "%3d" $percentage)%"
  fi
  local text="$1"
  echo -e "\033[0;32m $status -> \033[0m\033[0;01m $text\033[0;0m"

  if [[ $current_progress -eq $total_progress ]]; then
    current_progress=0
    total_progress=0
  fi
  bd::store::save total_progress current_progress
}
