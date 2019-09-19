if [ '-h' == "$1" ] || [ '--help' == "$1" ]; then
    echo "Usage:"
    echo "  sudo [options] ./build.sh"
    echo ""
    #
    echo "Options:"
    echo "  rktlabs_os=?"
    echo "      ? = \"alpine\" | \"ubuntu\" | \"archlinux\""
    echo "      skip is \"alpine\""
    echo "  rktlabs_app=?"
    echo "      if rktlabs_os is \"alpine\", ? = \"aria2\" | \"i2pd\" | \"playground\" | \"rutorrent\""
    echo "      if rktlabs_os is \"ubuntu\", ? = \"btsync\" | \"playground\" | \"rslsync\" | \"transmission\""
    echo "      if rktlabs_os is \"archlinux\", ? = \"ipfs\" | \"playground\""
    echo "      skip is \"playground\""
    echo "  acbuild_args_debug=?"
    echo "      ? = true | false, skip is false"
    #
    exit 0
fi

set -e

# 检查root权限
if [ "`id -u`" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

RKTLABS_ROOT=`pwd`

RKTLABS_OS=${rktlabs_os:-"alpine"}
RKTLABS_APP=${rktlabs_app:-"playground"}

ACBUILD_ARGS_DEBUG=${acbuild_args_debug:-"false"}

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
