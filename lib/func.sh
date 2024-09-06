function regexp() {
  #echo "[$1][$2][$3]"
  perl -n -e "/$1/ && printf \"$2\", \"$3\""
}

function resize_xterm() {
  echo -ne "\e[4;$2;$1t"
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

function cursor_on() {
  echo -ne "\e[?25h"
}

function cursor_off() {
  echo -ne "\e[?25l"
}

function mouse_on() {
  echo -ne "\e[?1002h\e[?25l"
}

function mouse_off() {
  echo -ne "\e[?1002l"
}

function read_char() {
  read -sn 1 CHAR
  CHAR_CODE=`printf "%d" \'$CHAR `
  MOUSE_COLUMN=""
  MOUSE_ROW=""
  MOUSE_TYPE=""

  if [ "$CHAR_CODE" -eq 27 ];then
    read -sn 1 CH
    if [ "$CH" = "[" ];then
      read -sn 1 CH
      if [ "$CH" = "M" ];then
        read -sn 1 CH
        CH=`printf "%d" \'$CH `
        if [ $CH -eq 0 ];then
          MOUSE_EVENT="down"
        else
          MOUSE_EVENT="up"
        fi

        read -sn 1 CH
        CH=`printf "%d" \'$CH `
        MOUSE_COLUMN=$(( CH - 32 ))

        read -sn 1 CH
        CH=`printf "%d" \'$CH `
        MOUSE_ROW=$(( CH - 32 ))
      fi
    fi
  fi
}
