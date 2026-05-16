function findroot() {
  local D=`pwd`
  while [ 1 ];do
    local F="$D/$1"
    F=`echo $F`
    if [ -e "$F" ];then
      f_dirname "$F"
      return 0
    fi 
    if [ "$D" = "/" ];then
      return 1
    fi
    D=`f_dirname "$D"`
  done
}

function s_trim() {
  local trimmed="$1"

  # Strip leading spaces.
  while [[ $trimmed == ' '* ]]; do
    trimmed="${trimmed## }"
  done
  # Strip trailing spaces.
  while [[ $trimmed == *' ' ]]; do
    trimmed="${trimmed%% }"
  done

  echo "$trimmed"
}

function f_basename() { 
  test -n "$1" || return 0
  local x="$1"; while :; do case "$x" in */) x="${x%?}";; *) break;; esac; done
  [ -n "$x" ] || { echo /; return; }
  printf '%s\n' "${x##*/}"; 
}

function f_basename_noext() { 
  test -n "$1" || return 0
  local x="$1"; while :; do case "$x" in */) x="${x%?}";; *) break;; esac; done
  [ -n "$x" ] || { echo /; return; }
  local s="${x##*/}"
  printf '%s\n' "${s%.*}"; 
}

function f_extname() {
  local x="$1"
  echo "${x##*.}"
}

function f_dirname() { 
  test -n "$1" || return 0
  local x="$1"; while :; do case "$x" in */) x="${x%?}";; *) break;; esac; done
  [ -n "$x" ] || { echo /; return; }
  set -- "$x"; x="${1%/*}"
  case "$x" in "$1") x=.;; "") x=/;; esac
  printf '%s\n' "$x"
}

function cmd_exists() {
  type "$1" 2>/dev/null >/dev/null
  return $?
}

function f_urlencode() {
  local old_lc_collate=$LC_COLLATE
  LC_COLLATE=C
    
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
      *) printf '%%%02X' "'$c" ;;
    esac
  done
  LC_COLLATE=$old_lc_collate
}

function f_urldecode() {
  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
}

function f_abspath() {
  case "$1" in
    /*) echo "$1";;
     *) echo "$PWD/$1";;
  esac
}

function checksum() {
  local C=`echo "$1" | md5sum | awk '{ print $1 }'`
  echo "$C"
}

function path_to_cache() {
  local x="$1"
  x=${x//$REPO_ROOT/}
  x=${x//\//dE1XK}
  echo "$REPO_CACHE/$x"
}

function cache_to_path() {
  local x="$1"
  x=${x//$REPO_CACHE\//}
  x=${x//dE1XK/\/}
  echo "$REPO_ROOT$x"
}

function f_mdate() {
  if [ -e "$1" ];then
    date -r "$1" +%Y%m%d%H%m.%S
  fi
}

function f_touch() {
  touch -t "$2" "$1"
}

function f_contentfile() {
  if [ -f "$1" ];then
    return 0
  else
    local v=`mdls -attr kMDItemContentTypeTree "$1" | grep com.apple.package`
    if [ -n "$v" ];then
      return 0
    else
      return 1
    fi
  fi
}

function f_filelist() {
  local base_path=`f_abspath "$1"`
  local filter="$2"
  local ignore="$3"
  local ifl=""
  local xfl=""
  local args=""
  local oldifs="$IFS"

  set -f
  IFS=":"

  # include files
  for DD in $filter ;do
    [ -n "$ifl" ] && ifl="$ifl -o "
    ifl="$ifl -name $DD"
  done

  # exclude files
  for DD in $ignore ;do
    [ -n "$xfl" ] && ifl="$xfl -o "
    xfl="$xfl -name $DD"
  done

  if [ -n "$xfl" ];then
    args="$args ( $xfl ) -prune -o "
  fi
  
  args="$args -type f ";
  if [ -n "$ifl" ];then
    args="$args ( $ifl )"
  fi
  
  args="$args -print"

  IFS="$oldifs"
  find "$base_path" $args
  set +f
}

function status_msg() {
  echo "M:$@" >/dev/stderr
}
