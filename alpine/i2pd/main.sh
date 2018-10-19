#!/bin/sh
set -e

ln -s $HOME_DIR/certificates $DATA_DIR/certificates

$HOME_DIR/bin/i2pd --datadir $DATA_DIR  --conf $DATA_DIR/i2pd.conf
