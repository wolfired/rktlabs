#!/bin/sh
set -e

COMMAND=/usr/local/bin/i2pd

mkdir -p ~/.i2pd
cp -R -u /i2pd/certificates ~/.i2pd

$COMMAND --service false --datadir ~/.i2pd --conf ~/.i2pd/i2pd.conf
