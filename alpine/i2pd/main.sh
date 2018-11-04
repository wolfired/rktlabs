#!/bin/sh
set -e

ln -s $APP_USER_HOME/certificates $APP_EXTERNAL_DIR/certificates

if [ -f "$APP_EXTERNAL_DIR/i2pd.conf" ]; then
    $APP_USER_BIN/i2pd --datadir $APP_EXTERNAL_DIR --service false --conf $APP_EXTERNAL_DIR/i2pd.conf
else
    $APP_USER_BIN/i2pd --datadir $APP_EXTERNAL_DIR --service false
fi
