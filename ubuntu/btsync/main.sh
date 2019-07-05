#!/bin/sh
set -e

COMMAND=/usr/local/bin/btsync

mkdir -p ~/.btsync/storage

$COMMAND --nodaemon --config ~/.btsync/config --log ~/.btsync/btsync.log
