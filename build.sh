#!/usr/bin/env bash

cd src
make install

cp gesture_helper ../libexec
chown root:root ../libexec/gesture_helper
chmod 4775      ../libexec/gesture_helper

cp keyboard_helper ../libexec
chown root:root ../libexec/keyboard_helper
chmod 4775      ../libexec/keyboard_helper
