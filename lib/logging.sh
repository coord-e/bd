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
    [debug]="\033[0;35m[DEBUG] \033[0m %s\n"
    [info]="\033[0;32m[INFO] \033[0m\033[0;01m %s\033[0;0m\n"
    [warn]="\033[0;33m[WARN] \033[0m\033[0;01m %s\033[0;0m\n"
    [error]="\033[0;31m[ERROR] \033[0m\033[0;01m %s\033[0;0m\n"
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