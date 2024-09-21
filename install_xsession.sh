#!/usr/bin/env bash

if [ -z "$TWDE_HOME" ];then
  TWDE_HOME=`pwd`
fi

echo "TWDE_HOME=$TWDE_HOME"
read -p "enter new value or confirm: " DD

echo ""
T="/tmp/$$twde.desktop"

export TWDE_HOME
$TWDE_HOME/bin/prepareconf ./lib/TWDE.desktop - > "$T"

if ! [ -f "$HOME/.twderc" ];then
  echo "TWDE_HOME=$TWDE_HOME" > "$HOME/.twderc"
fi

mv "$T" /usr/share/xsessions/TWDE.desktop
ln -s $TWDE_HOME/bin/starttwde /usr/bin/starttwde
