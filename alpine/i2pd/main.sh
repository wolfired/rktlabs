#!/bin/sh
set -e

$APP_BIN/i2pd --datadir $APP_BRIDGE/.i2pd --service false --conf $APP_BRIDGE/.i2pd/i2pd.conf
