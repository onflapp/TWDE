#!/bin/bash

cd src
make install
chown root:root $TWDE_HOME/libexec/gesture_helper
chmod 4775 $TWDE_HOME/libexec/gesture_helper
