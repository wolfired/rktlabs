#!/bin/sh
set -e

d=~/.i2pd
f=$d/i2pd.conf

if [ ! -d "$d" ]; then
    mkdir $d
fi

if [ !-f "$d/certificates"]; then
    ln -sf $APP_HOME/certificates $d/certificates
fi


if [ -f "$f" ]; then
    $APP_BIN/i2pd --datadir $d --service false --conf $f
else
    $APP_BIN/i2pd --datadir $d --service false
fi
