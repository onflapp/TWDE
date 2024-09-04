function regexp() {
  #echo "[$1][$2][$3]"
  perl -n -e "/$1/ && printf \"$2\", \"$3\""
}

function resize_xterm() {
  echo -e "\e[4;$2;$1t"
}

function locate_command() {
  local cmd="$1"
  local paths="/usr/local/bin /opt/bin /usr/bin"
  for p in $paths ;do
    if [ -x "$p/$cmd" ];then
      echo "$p/$cmd"
      return 0
    fi
  done
  echo "$cmd"
  return 1
}

function encode_url() {
  local len="${#1}"
  for ((n = 0; n < len; n++)); do
    local c="${1:n:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
                    *) printf '%%%02X' "'$c"
    esac
  done
}

function xroot_size() {
  xwininfo -root | while read -r LINE;do
    if [[ "$LINE" =~ Width:\ (.*) ]];then
      echo "WIDTH=${BASH_REMATCH[1]}"
    fi
    if [[ "$LINE" =~ Height:\ (.*) ]];then
      echo "HEIGHT=${BASH_REMATCH[1]}"
    fi
  done
}
