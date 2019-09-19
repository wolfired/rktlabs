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
    echo "  rktlabs_home_path=?"
    echo "      ? default is \"/home\""
    echo "  rkt_args_daemon=?"
    echo "      ? = true | false, skip is false"
    echo "  rkt_args_debug=?"
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
RKTLABS_HOME_PATH=${rktlabs_home_path:-"/home"}

RKT_ARGS_DAEMON=${rkt_args_daemon:-"false"}
RKT_ARGS_DEBUG=${rkt_args_debug:-"false"}
RKT_ARGS_INTERACTIVE=${rkt_args_interactive:-"true"}

APP_MAIN_SH=${RKTLABS_ROOT}/${RKTLABS_OS}/${RKTLABS_APP}/main.sh

if [ ! -f ${APP_MAIN_SH} ]; then
    echo "no os or app"
    exit 1
fi

RKTLABS_USER=${RKTLABS_USER:-${SUDO_USER}}
RKTLABS_USER_ID=${RKTLABS_USER_ID:-`id ${SUDO_USER} -u`}
RKTLABS_GROUP=${RKTLABS_GROUP:-`id ${SUDO_USER} -gn`}
RKTLABS_GROUP_ID=${RKTLABS_GROUP_ID:-`id ${SUDO_USER} -g`}

RKTLABS_USER_HOME=${RKTLABS_USER_HOME:-"${RKTLABS_HOME_PATH}/${RKTLABS_USER}/.rktlabs/${RKTLABS_OS}"}

if [ ! -d ${RKTLABS_USER_HOME} ]; then
    mkdir -p ${RKTLABS_USER_HOME}
fi

cp -u ${APP_MAIN_SH} $RKTLABS_USER_HOME/${RKTLABS_APP}.sh
chmod 754 $RKTLABS_USER_HOME/${RKTLABS_APP}.sh
chown -R ${RKTLABS_USER}:${RKTLABS_GROUP} ${RKTLABS_USER_HOME}

daemon=
if [ "true" = ${RKT_ARGS_DAEMON} ]; then
    daemon="systemd-run --slice=machine"
fi

$daemon rkt --insecure-options=image run --debug=${RKT_ARGS_DEBUG} --interactive=${RKT_ARGS_INTERACTIVE} ${RKTLABS_ROOT}/${RKTLABS_OS}/${RKTLABS_APP}/out.aci \
--set-env HOME=/home/${RKTLABS_USER} \
--hostname=${RKTLABS_APP} --net=host --dns=223.5.5.5 \
--user=${RKTLABS_USER_ID} --group=${RKTLABS_GROUP_ID} \
--seccomp=mode=retain,@rkt/default-whitelist,errno=EPERM \
--volume home,kind=host,source=${RKTLABS_USER_HOME},readOnly=false
