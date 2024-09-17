#!/usr/bin/env bash

cd src
make install

chown root:root $TWDE_HOME/libexec/gesture_helper
chmod 4775 $TWDE_HOME/libexec/gesture_helper

chown root:root $TWDE_HOME/libexec/keyboard_helper
chmod 4775 $TWDE_HOME/libexec/keyboard_helper
