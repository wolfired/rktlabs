#!/bin/sh
set -e

ln -sf ~/certificates ~/external/certificates

if [ -f "~/external/i2pd.conf" ]; then
    ~/bin/i2pd --datadir ~/external --service false --conf ~/external/i2pd.conf
else
    ~/bin/i2pd --datadir ~/external --service false
fi
