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

ACBUILD_ARGS_DEBUG=${ACBUILD_ARGS_DEBUG:-"false"}

if [ "true" = ${ACBUILD_ARGS_DEBUG} ]; then
    ACBUILD_ARGS_DEBUG="--debug"
else
    ACBUILD_ARGS_DEBUG=""
fi

APP_BUILD_SH=${RKTLABS_ROOT}/${RKTLABS_OS}/${RKTLABS_APP}/build.sh

if [ ! -f ${APP_BUILD_SH} ]; then
    echo "no os or app"
    exit 1
fi

# 设置app参数
APP_PATH=$(dirname ${APP_BUILD_SH})
OS_PATH=$(dirname "$APP_PATH")
RKTLABS_PATH=$(dirname "$OS_PATH")


. ${APP_BUILD_SH}
