#!/bin/sh
set -e

local d=~/.i2pd
local f=$d/i2pd.conf

if [ ! -d "$d" ]; then
    mkdir $d
if

ln -sf $APP_HOME/certificates $d/certificates

if [ -f "$f" ]; then
    $APP_BIN/i2pd --datadir $d --service false --conf $f
else
    $APP_BIN/i2pd --datadir $d --service false
fi
