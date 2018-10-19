#!/bin/sh
set -e

ln -s $DIR_HOME/certificates $DIR_DATA/certificates

$DIR_BIN/i2pd --datadir $DIR_DATA --conf $DIR_DATA/i2pd.conf
