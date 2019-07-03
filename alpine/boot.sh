#!/bin/sh
set -e

if [ ! -f $APP_BRIDGE/main.sh ]; then echo "no main.sh" && exit 1; fi && $APP_BRIDGE/main.sh
