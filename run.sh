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

RKTLABS_USER=${RKTLABS_USER:-${SUDO_USER}}
RKTLABS_USER_ID=${RKTLABS_USER_ID:-`id ${SUDO_USER} -u`}
RKTLABS_GROUP=${RKTLABS_GROUP:-`id ${SUDO_USER} -gn`}
RKTLABS_GROUP_ID=${RKTLABS_GROUP_ID:-`id ${SUDO_USER} -g`}

RKTLABS_OS_ROOT=${RKTLABS_OS_ROOT:-"/home/$RKTLABS_USER/.rktlabs/$RKTLABS_OS"}
RKTLABS_APP_ROOT=${RKTLABS_APP_ROOT:-"${RKTLABS_OS_ROOT}/$RKTLABS_APP"}

if [ ! -d "$RKTLABS_APP_ROOT" ]; then
    mkdir -p $RKTLABS_OS_ROOT $RKTLABS_APP_ROOT
    cp `pwd`/$RKTLABS_OS/$RKTLABS_APP/main.sh $RKTLABS_APP_ROOT
    chown -R $RKTLABS_USER:$RKTLABS_GROUP $RKTLABS_OS_ROOT
fi

systemd-run --slice=machine rkt --insecure-options=image run --debug=$RKT_ARGS_DEBUG --interactive=$RKT_ARGS_INTERACTIVE `pwd`/$RKTLABS_OS/$RKTLABS_APP/out.aci \
--hostname=$RKTLABS_APP --net=host --dns=223.5.5.5 \
--user=$RKTLABS_USER_ID --group=$RKTLABS_GROUP_ID \
--seccomp=mode=retain,@rkt/default-whitelist,errno=EPERM \
--volume bridge,kind=host,source=$RKTLABS_APP_ROOT,readOnly=false
