#!/bin/sh
set -e

mkdir -p ~/.rslsync/storage

/usr/local/bin/rslsync --nodaemon --config ~/.rslsync/config --log ~/.rslsync/rslsync.log
