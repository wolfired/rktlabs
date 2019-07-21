#!/bin/sh
set -e

DATA_ROOT=${DATA_ROOT:-"/rktdata"}

mkdir -p ~/.i2pd
cp -R -u $DATA_ROOT/certificates ~/.i2pd

/usr/local/bin/i2pd --service false --datadir ~/.i2pd --conf ~/.i2pd/i2pd.conf
