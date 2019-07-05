#!/bin/sh
set -e

COMMAND=/usr/local/bin/rslsync

mkdir -p ~/.rslsync/storage

$COMMAND --nodaemon --config ~/.rslsync/config --log ~/.rslsync/rslsync.log
