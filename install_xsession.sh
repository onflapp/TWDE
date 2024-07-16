#!/bin/bash

if [ -z "$TWDE_HOME" ];then
  TWDE_HOME=`pwd`
fi

echo "TWDE_HOME=$TWDE_HOME"
read -p "enter new value or confirm: " DD

echo ""
T="/tmp/$$twde.desktop"

export TWDE_HOME
./bin/prepareconf - ./lib/TWDE.desktop "$T"

if ! [ -f "$HOME/.twderc" ];then
  echo "TWDE_HOME=$TWDE_HOME" > "$HOME/.twderc"
fi

sudo mv "$T" /usr/share/xsessions/TWDE.desktop
