function bd::cmd::iter() {
  local iterations=$(eval "echo $@")
  local iterations=$(eval "echo $@")
  bd_total_progress=$(wc -w <<< $iterations)
  bd_current_progress=0
  bd::store::save bd_total_progress bd_current_progress
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
  bd::store::load bd_current_progress bd_total_progress
  bd_current_progress=$((bd_current_progress += 1))
  if [[ "$bd_total_progress" == "0" ]]; then
    local status="$(printf "%3d" $bd_current_progress)."
  else
    local percentage=$(( bd_current_progress * 100 / bd_total_progress ))
    local status="$(printf "%3d" $percentage)%"
  fi
  local text="$1"
  echo -e "\033[0;32m $status -> \033[0m\033[0;01m $text\033[0;0m"

  if [[ $bd_current_progress -eq $bd_total_progress ]]; then
    bd_current_progress=0
    bd_total_progress=0
  fi
  bd::store::save bd_total_progress bd_current_progress
}
