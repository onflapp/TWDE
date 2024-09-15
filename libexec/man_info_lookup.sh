#!/usr/bin/env bash

WORD="$1"

. $TWDE_HOME/etc/manual.conf

while [ -z "$WORD" ];do
  echo "manpage for? "
  read WORD
done

export MANWIDTH="$(($WIDTH - 2))"
export MANPAGER="$PAGER"

man "$WORD"
