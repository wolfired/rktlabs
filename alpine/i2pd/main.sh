#!/bin/sh
set -e

ln -s "$I2PD_HOME"/certificates "$DATA_DIR"/certificates

$I2PD_HOME/bin/i2pd --datadir "$DATA_DIR"  --conf "$DATA_DIR"/i2pd.conf
