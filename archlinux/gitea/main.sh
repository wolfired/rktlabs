#!/bin/sh
set -e

GITEA_WORK_DIR=/home/link/.gitea/ /bin/gitea web -c /home/link/.gitea/app.ini
