function bd::cmd::debug (){
  echo -e "\033[0;69m[DEBUG] \033[0m\033[0;01m $1\033[0;0m" >&2
}

function bd::cmd::info (){
  echo -e "\033[0;32m[INFO] \033[0m\033[0;01m $1\033[0;0m" >&2
}

function bd::cmd::error (){
  echo -e "\033[0;31m[ERROR] \033[0m\033[0;01m $1\033[0;0m" >&2
}

function bd::cmd::error_exit () {
  error "$1"
  exit ${2:--1}
}

function bd::cmd::warn (){
  echo -e "\033[0;33m[WARN] \033[0m\033[0;01m $1\033[0;0m" >&2
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
