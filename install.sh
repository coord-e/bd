#!/usr/bin/env bash
set -ue -o pipefail
readonly BD_EJECTED=true
readonly BD_CACHE="$HOME/.cache/bd"

if [ -v BD_EJECTED ]; then
  BD_SCRIPT=$0
else
  BD_SCRIPT=$1
  shift
fi

BD_ARGS=($@)
BD_SCRIPT_NAME=$BD_SCRIPT

bd_total_progress=0
bd_current_progress=0

# BD_P_ variables are set before startup, and they're immutable after setup
BD_P_DEFAULT_EJECTED_FUNCTIONS=()

# Startup code always have to return 0
BD_P_STARTUP_CODE=("[ ! -d $BD_CACHE ] && mkdir -p $BD_CACHE || :")

BD_LOG_LEVEL=${BD_LOG_LEVEL:-info}
declare -a BD_P_DEFAULT_EJECTED_FUNCTIONS=([0]="bd::store::save" [1]="bd::store::load")
declare -a BD_P_STARTUP_CODE=([0]="[ ! -d /root/.cache/bd ] && mkdir -p /root/.cache/bd || :" [1]="bd::store::save bd_total_progress bd_current_progress")
name () 
{ 
    BD_SCRIPT_NAME=$1
}
description () 
{ 
    if [ -t 1 ]; then
        BD_SCRIPT_DESCRIPTION=$(cat);
    else
        BD_SCRIPT_DESCRIPTION=$@;
    fi
}
info () 
{ 
    log info "$@"
}
log () 
{ 
    local loglevel=$1;
    shift;
    local content=$@;
    declare -A level2num=([debug]=0 [info]=1 [warn]=2 [error]=3);
    if [ -z "${level2num[$BD_LOG_LEVEL]}" ]; then
        local invalid_one=$BD_LOG_LEVEL;
        BD_LOG_LEVEL=info;
        bd::logger::error_exit "Invalid log level \"$invalid_one\"";
    fi;
    if [ ${level2num[$loglevel]} -lt ${level2num[$BD_LOG_LEVEL]} ]; then
        return;
    fi;
    declare -A level2fmt=([debug]="\033[0;35m[DEBUG] \033[0m %s\n" [info]="\033[0;32m[INFO] \033[0m\033[0;01m %s\033[0;0m\n" [warn]="\033[0;33m[WARN] \033[0m\033[0;01m %s\033[0;0m\n" [error]="\033[0;31m[ERROR] \033[0m\033[0;01m %s\033[0;0m\n");
    printf "${level2fmt[$loglevel]}" "$content" 1>&2
}
bd::logger::error () 
{ 
    error "bd: $@"
}
error () 
{ 
    log error "$@"
}
bd::logger::error_exit () 
{ 
    error_exit "bd: $@"
}
error_exit () 
{ 
    error "$1";
    exit ${2:--1}
}
confirm () 
{ 
    local MSG=$1;
    while true; do
        printf '%s ' "$MSG";
        printf "[y/n] > ";
        read input;
        if [ "$input" = "y" ]; then
            return 0;
        else
            if [ "$input" = "n" ]; then
                return 1;
            fi;
        fi;
    done
}
progress () 
{ 
    bd::store::load bd_current_progress bd_total_progress;
    bd_current_progress=$((bd_current_progress += 1));
    if [[ "$bd_total_progress" == "0" ]]; then
        local status="$(printf "%3d" $bd_current_progress).";
    else
        local percentage=$(( bd_current_progress * 100 / bd_total_progress ));
        local status="$(printf "%3d" $percentage)%";
    fi;
    local text="$1";
    echo -e "\033[0;32m $status -> \033[0m\033[0;01m $text\033[0;0m";
    if [[ $bd_current_progress -eq $bd_total_progress ]]; then
        bd_current_progress=0;
        bd_total_progress=0;
    fi;
    bd::store::save bd_total_progress bd_current_progress
}
bd::store::load () 
{ 
    for key in $@;
    do
        local path=$BD_CACHE/$key;
        if [ -f $path.ary ]; then
            path=$path.ary;
        else
            if [ ! -f $path ]; then
                bd::logger::warn "loading variable \"$key\", which is not defined";
            fi;
        fi;
        local value=$(cat $path);
        if [[ "$path" == *.ary ]]; then
            eval "$key=($value)";
        else
            eval "$key=\"$value\"";
        fi;
    done
}
bd::logger::warn () 
{ 
    warn "bd: $@"
}
warn () 
{ 
    log warn "$@"
}
bd::store::save () 
{ 
    for key in $@;
    do
        if [[ "$(declare -p $key)" =~ "declare -a" ]]; then
            local value=$(eval "echo \"\${$key[@]}\"");
            local path=$BD_CACHE/$key.ary;
        else
            if [ ! -v $key ]; then
                bd::logger::warn "saving variable \"$key\", which is not defined";
            else
                local value=$(eval "echo \"\$$key\"");
                local path=$BD_CACHE/$key;
            fi;
        fi;
        echo "$value" > $path;
    done
}
bd::run () 
{ 
    local script=$1;
    for name in $(compgen -A function);
    do
        if [[ "$name" == * ]]; then
            local definition=$(declare -f $name);
            eval "${definition#}";
        fi;
    done;
    source $script
}
bd::run_startup () 
{ 
    for cmd in "${BD_P_STARTUP_CODE[@]}";
    do
        eval "$cmd";
    done
}
[ ! -d /root/.cache/bd ] && mkdir -p /root/.cache/bd || :
bd::store::save bd_total_progress bd_current_progress
#!/usr/bin/env bd

readonly INSTALL_VERSION=1.0.0

name "bd installer script"
description << EOF
Install bd, the bash framework to build CLI tools.
EOF

info "Welcome to bd!"

confirm "This script will install bd to '~/.bd'. Proceed?" || error_exit "Aborting installation"

info "Starting the installation..."

progress "Checking the current installation..."
if type bd > /dev/null 2>&1; then
  warn "It seems that bd is already installed."
  confirm "Overwrite?"
  info "Launching uninstaller"
  eval "$(bd uninstall -)"
  info "Uninstalled the previous installation."
  bd::run_startup
fi

progress "Checking the version of bash..."
[ "${BASH_VERSINFO}" -lt 4 ] && error_exit "bd requires bash >= 4, however you have version ${BASH_VERSINFO}. Aborting"

progress "Downloading bd v${INSTALL_VERSION}..."
pushd /tmp > /dev/null
wget https://github.com/coord-e/bd/archive/v${INSTALL_VERSION}.tar.gz -O bd.tar.gz

progress "Extracting..."
tar xf bd.tar.gz

progress "Installing..."
cp -r ./bd-${INSTALL_VERSION} $HOME/.bd

progress "Cleaning up downloaded files..."
rm -r bd.tar.gz bd-${INSTALL_VERSION}
popd > /dev/null

progress "Appending the installation path to PATH..."
for profile_file in ".bash_profile" ".zprofile" ".profile"; do
  profile_path="$HOME/$profile_file"
  if [ -f "$profile_path" ]; then
    echo 'export PATH="~/.bd/bin:$PATH"' >> "$profile_path"
  fi
done

info "Done!"

info "Restart your shell so the path changes take effect."
info 'e.g. exec -l $SHELL'
