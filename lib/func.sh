function regexp() {
  #echo "[$1][$2][$3]"
  perl -n -e "/$1/ && printf \"$2\", \"$3\""
}

function resize_xterm() {
  echo -e "\e[4;$2;$1t"
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
