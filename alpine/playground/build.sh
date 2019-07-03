#!/bin/sh
set -e

# 检查root权限
if [ "`id -u`" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# 设置app参数
BUILD_PATH=$(dirname "$0")
OS_PATH=$(dirname "$BUILD_PATH")

APP_NAME=${BUILD_PATH##*/}
APP_ID=${APP_ID:-"wolfired.com/$APP_NAME"}

APP_USER=${APP_USER:-${SUDO_USER}}
APP_USER_ID=${APP_USER_ID:-`id ${SUDO_USER} -u`}
APP_GROUP=${APP_GROUP:-`id ${SUDO_USER} -gn`}
APP_GROUP_ID=${APP_GROUP_ID:-`id ${SUDO_USER} -g`}

USER_HOME=${USER_HOME:-"/home/$APP_USER"}

APP_HOME=${APP_HOME:-"$USER_HOME/$APP_NAME"}
APP_BIN=${APP_BIN:-"$APP_HOME/bin"}

APP_BRIDGE=${APP_BRIDGE:-"$APP_HOME/bridge"}

REPO_NAME=${REPO_NAME:-""}
REPO_URL=${REPO_URL:-""}
GIT_BRANCH=${GIT_BRANCH:-""}
GIT_TAG=${GIT_TAG:-""}

# 开始构建ACI
acbuild --debug begin $OS_PATH/base.aci

# 退出脚本前, 结束构建ACI
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

# 命名ACI
acbuild --debug set-name $APP_ID

# 创建目录与用户
acbuild --debug run -- mkdir -p $USER_HOME $APP_HOME $APP_BIN $APP_BRIDGE
acbuild --debug run -- addgroup -g $APP_GROUP_ID -S $APP_GROUP
acbuild --debug run -- adduser -S -h $USER_HOME -G $APP_GROUP -u $APP_USER_ID $APP_USER
acbuild --debug run -- chown -R $APP_USER:$APP_GROUP $USER_HOME

# 更新系统
acbuild --debug run -- /bin/sh -c "echo 'https://mirrors.ustc.edu.cn/alpine/latest-stable/main' > /etc/apk/repositories"
acbuild --debug run -- /bin/sh -c "echo 'https://mirrors.ustc.edu.cn/alpine/latest-stable/community' >> /etc/apk/repositories"
acbuild --debug run -- /bin/sh -c "apk update && apk upgrade"

# 安装编译依赖

# 编译, 安装

# 清理编译依赖

# 安装运行依赖

#指定容器运行用户和用户级
acbuild --debug set-user $APP_USER
acbuild --debug set-group $APP_GROUP

acbuild --debug mount add bridge $APP_BRIDGE

acbuild --debug copy $OS_PATH/boot.sh $APP_BIN/boot.sh
acbuild --debug run -- chmod a+x $APP_BIN/boot.sh

acbuild --debug run -- chown -R $APP_USER:$APP_GROUP $USER_HOME

acbuild --debug set-user $APP_USER
acbuild --debug set-working-directory $APP_BRIDGE

acbuild --debug environment add APP_HOME $APP_HOME
acbuild --debug environment add APP_BIN $APP_BIN
acbuild --debug environment add APP_BRIDGE $APP_BRIDGE

acbuild --debug set-exec -- /bin/sh -c "$APP_BIN/boot.sh"

# Save the ACI
acbuild --debug write --overwrite $BUILD_PATH/out.aci
