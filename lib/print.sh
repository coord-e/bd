function info (){
  echo -e "\033[0;32m[INFO] \033[0m\033[0;01m $1\033[0;0m" >&2
}

function error (){
  echo -e "\033[0;31m[ERROR] \033[0m\033[0;01m $1\033[0;0m" >&2
}

function warn (){
  echo -e "\033[0;33m[WARN] \033[0m\033[0;01m $1\033[0;0m" >&2
}

