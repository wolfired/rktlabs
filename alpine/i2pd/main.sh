#!/bin/sh
set -e

ln -s $APP_USER_HOME/certificates $APP_EXTERNAL_DIR/certificates

$APP_USER_BIN/i2pd --datadir $APP_EXTERNAL_DIR --conf $APP_EXTERNAL_DIR/i2pd.conf
