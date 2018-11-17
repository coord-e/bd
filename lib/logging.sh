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

  declare -A level2fmt=(
    [debug]="$(tput setaf 5)[DEBUG] $(tput sgr0) %s\n"
    [info]="$(tput setaf 2)[INFO] $(tput sgr0)$(tput bold) %s$(tput sgr0)\n"
    [warn]="$(tput setaf 3)[WARN] $(tput sgr0)$(tput bold) %s$(tput sgr0)\n"
    [error]="$(tput setaf 1)[ERROR] $(tput sgr0)$(tput bold) %s$(tput sgr0)\n"
  )

  printf "${level2fmt[$loglevel]}" "$content" >&2
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
