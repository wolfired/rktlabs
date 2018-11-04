#!/bin/sh
set -e

# 检查root权限
if [ "`id -u`" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

RKTLABS_OS=${RKTLABS_OS:-"alpine"}

RKTLABS_APP_NAME=${RKTLABS_APP_NAME:-"playground"}

RKTLABS_APP_USER=${RKTLABS_APP_USER:-"rktlabs"}
RKTLABS_APP_USER_ID=${RKTLABS_APP_USER_ID:-"8181"}
RKTLABS_APP_GROUP=${RKTLABS_APP_GROUP:-"rktlabs"}
RKTLABS_APP_GROUP_ID=${RKTLABS_APP_GROUP_ID:-"8181"}

RKTLABS_APP_USER_HOME=${RKTLABS_APP_USER_HOME:-"/home/$RKTLABS_APP_USER/$RKTLABS_OS/$RKTLABS_APP_NAME"}
RKTLABS_APP_EXTERNAL_DIR=${RKTLABS_APP_EXTERNAL_DIR:-"$RKTLABS_APP_USER_HOME/external"}

if [ ! -d "$RKTLABS_APP_EXTERNAL_DIR" ]; then
    mkdir -p $RKTLABS_APP_EXTERNAL_DIR
    chown $RKTLABS_APP_USER:$RKTLABS_APP_GROUP $RKTLABS_APP_EXTERNAL_DIR
fi

rkt --insecure-options=image run --interactive=true `pwd`/$RKTLABS_OS/$RKTLABS_APP_NAME/out.aci \
--hostname=$RKTLABS_APP_NAME --net=host --dns=223.5.5.5 \
--user=$RKTLABS_APP_USER_ID --group=$RKTLABS_APP_GROUP_ID \
--volume external,kind=host,source=$RKTLABS_APP_EXTERNAL_DIR,readOnly=false
