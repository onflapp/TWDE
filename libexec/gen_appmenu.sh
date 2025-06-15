#!/usr/bin/env bash

. $TWDE_HOME/lib/func.sh

function current_name() {
  local IFS_OLD="$IFS"
  local WID=`xdotool getwindowfocus`
  local PAT="^WM_CLASS\\(STRING\\) = \\\"(.*)\\\","
  xprop -id $WID | while IFS= read -r LINE ;do
    if [[ "$LINE" =~ $PAT ]];then
      echo "${BASH_REMATCH[1]}"
    fi
  done

  IFS="$IFS_OLD"
}

function read_menu() {
  local IFS_OLD="$IFS"

  while IFS= read -r LINE ;do
    IFS=$'\t';V=(${LINE});IFS=
    NAME="${V[0]}"
    CMD="${V[1]}"
    echo "AddToMenu $MENU_NAME \"$NAME\" Exec $CMD"
  done < "$1"

  IFS="$IFS_OLD"
}

function gen_menu() {
  local N="$TWDE_HOME/etc/$1"
  if [ -f "$N" ];then
    read_menu "$N"
    return 0
  else
    return 1
  fi
}


MENU_NAME="$1"
APP_NAME=`current_name`

#echo "AddToMenu $MENU_NAME $APP_NAME Title"
gen_menu "appmenu-$APP_NAME.menu" || gen_menu "appmenu.menu"

echo "AddToMenu $MENU_NAME \"\" Nop"
echo "AddToMenu $MENU_NAME \"$APP_NAME\" Exec editor $TWDE_HOME/etc/appmenu-$APP_NAME.menu"
