#!/usr/bin/env bash

cd src
mkdir obj 2>/dev/null

make install

cp ./obj/gesture_helper ../libexec
chown root:root ../libexec/gesture_helper
chmod 4775      ../libexec/gesture_helper

cp ./obj/keyboard_helper ../libexec
chown root:root ../libexec/keyboard_helper
chmod 4775      ../libexec/keyboard_helper
