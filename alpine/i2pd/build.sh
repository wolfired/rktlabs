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

REPO_NAME=${REPO_NAME:-"i2pd"}
REPO_URL=${REPO_URL:-"https://github.com/PurpleI2P/i2pd.git"}
GIT_BRANCH=${GIT_BRANCH:-"openssl"}
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
acbuild --debug run -- apk --no-cache --virtual build-dependendencies add make gcc g++ libtool boost-dev build-base openssl-dev openssl git zlib-dev

# 编译, 安装
acbuild --debug run -- mkdir -p /build
acbuild --debug run --working-dir=/build -- git clone -b $GIT_BRANCH $REPO_URL
if [ -n "${GIT_TAG}" ]; then
    acbuild --debug run --working-dir=/build/$REPO_NAME -- git checkout tags/${GIT_TAG}
fi
acbuild --debug run --working-dir=/build/$REPO_NAME -- make
acbuild --debug run --working-dir=/build/$REPO_NAME -- cp -R contrib/certificates $APP_HOME
acbuild --debug run --working-dir=/build/$REPO_NAME -- mv i2pd $APP_BIN
acbuild --debug run -- strip $APP_BIN/i2pd
acbuild --debug run -- rm -rf /build

# 清理编译依赖
acbuild --debug run -- apk --no-cache --purge del build-dependendencies

# 安装运行依赖
acbuild --debug run -- apk --no-cache add boost-filesystem boost-system boost-program_options boost-date_time boost-thread boost-iostreams openssl musl-utils libstdc++

#指定容器运行用户和用户级
acbuild --debug set-user $APP_USER
acbuild --debug set-group $APP_USER

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

# 保存ACI
acbuild --debug write --overwrite $BUILD_PATH/out.aci
