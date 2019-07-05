#!/bin/sh
set -e

mkdir -p ~/.aria2/download

aria2c --conf-path ~/.aria2/aria2.conf
