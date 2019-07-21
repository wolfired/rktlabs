#!/bin/sh
set -e

# 检查root权限
if [ "`id -u`" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

RKTLABS_ROOT=`pwd`

RKTLABS_OS=${RKTLABS_OS:-"alpine"}
RKTLABS_APP=${RKTLABS_APP:-"playground"}

RKT_ARGS_DAEMON=${RKT_ARGS_DAEMON:-"false"}
RKT_ARGS_DEBUG=${RKT_ARGS_DEBUG:-"false"}
RKT_ARGS_INTERACTIVE=${RKT_ARGS_INTERACTIVE:-"true"}

APP_MAIN_SH=${RKTLABS_ROOT}/${RKTLABS_OS}/${RKTLABS_APP}/main.sh

if [ ! -f ${APP_MAIN_SH} ]; then
    echo "no os or app"
    exit 1
fi

RKTLABS_USER=${RKTLABS_USER:-${SUDO_USER}}
RKTLABS_USER_ID=${RKTLABS_USER_ID:-`id ${SUDO_USER} -u`}
RKTLABS_GROUP=${RKTLABS_GROUP:-`id ${SUDO_USER} -gn`}
RKTLABS_GROUP_ID=${RKTLABS_GROUP_ID:-`id ${SUDO_USER} -g`}

RKTLABS_USER_HOME=${RKTLABS_USER_HOME:-"/home/${RKTLABS_USER}/.rktlabs/${RKTLABS_OS}"}

if [ ! -d ${RKTLABS_USER_HOME} ]; then
    mkdir -p ${RKTLABS_USER_HOME}
fi

cp -u ${APP_MAIN_SH} $RKTLABS_USER_HOME/${RKTLABS_APP}.sh
chmod 754 $RKTLABS_USER_HOME/${RKTLABS_APP}.sh
chown -R ${RKTLABS_USER}:${RKTLABS_GROUP} ${RKTLABS_USER_HOME}

#systemd-run --slice=machine
daemon=
if [ "true" = ${RKT_ARGS_DAEMON} ]; then
    daemon="systemd-run --slice=machine"
fi

$daemon rkt --insecure-options=image run --debug=${RKT_ARGS_DEBUG} --interactive=${RKT_ARGS_INTERACTIVE} ${RKTLABS_ROOT}/${RKTLABS_OS}/${RKTLABS_APP}/out.aci \
--set-env HOME=/home/${RKTLABS_USER} \
--hostname=${RKTLABS_APP} --net=host --dns=223.5.5.5 \
--user=0 --group=0 \
--seccomp=mode=retain,@rkt/default-whitelist,errno=EPERM \
--volume home,kind=host,source=${RKTLABS_USER_HOME},readOnly=false
