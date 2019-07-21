#!/bin/sh
set -e

mkdir -p ~/.btsync/storage

/usr/local/bin/btsync --nodaemon --config ~/.btsync/config --log ~/.btsync/btsync.log
