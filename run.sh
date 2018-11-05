#!/bin/sh
set -e

# 检查root权限
if [ "`id -u`" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

RKT_ARGS_DEBUG=${RKT_ARGS_DEBUG:-"false"}
RKT_ARGS_INTERACTIVE=${RKT_ARGS_INTERACTIVE:-"true"}

RKTLABS_OS=${RKTLABS_OS:-"alpine"}

RKTLABS_APP=${RKTLABS_APP:-"playground"}

RKTLABS_USER=${RKTLABS_USER:-"rktlabs"}
RKTLABS_USER_ID=${RKTLABS_USER_ID:-"8181"}
RKTLABS_GROUP=${RKTLABS_GROUP:-"rktlabs"}
RKTLABS_GROUP_ID=${RKTLABS_GROUP_ID:-"8181"}

RKTLABS_APP_ROOT=${RKTLABS_APP_ROOT:-"/home/$RKTLABS_USER/$RKTLABS_OS/$RKTLABS_APP"}

if [ ! -d "$RKTLABS_APP_ROOT" ]; then
    mkdir -p $RKTLABS_APP_ROOT
    chown $RKTLABS_USER:$RKTLABS_GROUP $RKTLABS_APP_ROOT
fi

rkt --insecure-options=image run --debug=$RKT_ARGS_DEBUG --interactive=$RKT_ARGS_INTERACTIVE `pwd`/$RKTLABS_OS/$RKTLABS_APP/out.aci \
--hostname=$RKTLABS_APP --net=host --dns=223.5.5.5 \
--user=$RKTLABS_USER_ID --group=$RKTLABS_GROUP_ID \
--volume bridge,kind=host,source=$RKTLABS_APP_ROOT,readOnly=false
