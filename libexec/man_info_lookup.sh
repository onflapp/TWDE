#!/bin/bash

WORD="$1"

while [ -z "$WORD" ];do
  echo "manpage for? "
  read WORD
done

man "$WORD"
