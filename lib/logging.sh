function bd::cmd::log() {
  local loglevel=$1
  shift
  local content=$@

  declare -A level2num=(
    [debug]=0
    [info]=1
    [warn]=2
    [error]=3
  )

  if [ -z "${level2num[$BD_LOG_LEVEL]}" ]; then
    local invalid_one=$BD_LOG_LEVEL
    BD_LOG_LEVEL=info
    bd::logger::error_exit "Invalid log level \"$invalid_one\""
  fi

  if [ ${level2num[$loglevel]} -lt ${level2num[$BD_LOG_LEVEL]} ]; then
    return
  fi

  declare -A level2header=(
    [debug]="$(tput setaf 5)[DEBUG]$(tput sgr0)"
    [info]="$(tput setaf 2)[INFO]$(tput sgr0)"
    [warn]="$(tput setaf 3)[WARN]$(tput sgr0)"
    [error]="$(tput setaf 1)[ERROR]$(tput sgr0)"
  )
  # TODO: Calculate suitable length based on each header length
  local header_length=16

  declare -A level2fmt=(
    [debug]="%s\n"
    [info]="$(tput bold)%s$(tput sgr0)\n"
    [warn]="$(tput bold)%s$(tput sgr0)\n"
    [error]="$(tput bold)%s$(tput sgr0)\n"
  )

  printf "%-${header_length}s  ${level2fmt[$loglevel]}" "${level2header[$loglevel]}" "$content" >&2
}

function bd::cmd::debug (){
  bd::cmd::log debug "$@"
}

function bd::cmd::info (){
  bd::cmd::log info "$@"
}

function bd::cmd::error (){
  bd::cmd::log error "$@"
}

function bd::cmd::error_exit () {
  bd::cmd::error "$1"
  exit ${2:--1}
}

function bd::cmd::warn (){
  bd::cmd::log warn "$@"
}

function bd::logger::debug () {
  bd::cmd::debug "bd: $@"
}

function bd::logger::info () {
  bd::cmd::info "bd: $@"
}

function bd::logger::error () {
  bd::cmd::error "bd: $@"
}

function bd::logger::error_exit () {
  bd::cmd::error_exit "bd: $@"
}

function bd::logger::warn (){
  bd::cmd::warn "bd: $@"
}
