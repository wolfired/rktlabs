#!/bin/sh
set -e

# 检查root权限
if [ "`id -u`" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# 设置app参数
APP_NAME=`pwd`
APP_NAME=${APP_NAME##*/}

APP_ID=${APP_ID:-"wolfired.com/$APP_NAME"}

APP_USER=${APP_USER:-"rktlabs"}
APP_USER_ID=${APP_USER_ID:-"8181"}
APP_GROUP=${APP_GROUP:-"rktlabs"}
APP_GROUP_ID=${APP_GROUP_ID:-"8181"}

USER_HOME=${USER_HOME:-"/home/$APP_USER"}

APP_HOME=${APP_HOME:-"$USER_HOME/$APP_NAME"}
APP_BIN=${APP_BIN:-"$APP_HOME/bin"}

APP_ROOT=${APP_ROOT:-"/home/$APP_NAME"}

REPO_NAME=${REPO_NAME:-""}
REPO_URL=${REPO_URL:-""}
GIT_BRANCH=${GIT_BRANCH:-""}
GIT_TAG=${GIT_TAG:-""}

# 开始构建ACI
acbuild --debug begin ../base.aci

# 退出脚本前, 结束构建ACI
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

# 命名ACI
acbuild --debug set-name $APP_ID

#
acbuild --debug run -- mkdir -p $USER_HOME $APP_HOME $APP_BIN $APP_ROOT
acbuild --debug run -- addgroup -g $APP_GROUP_ID -S $APP_GROUP
acbuild --debug run -- adduser -S -h $USER_HOME -G $APP_GROUP -u $APP_USER_ID $APP_USER
acbuild --debug run -- chown -R $APP_USER:$APP_GROUP $USER_HOME
acbuild --debug run -- chown -R $APP_USER:$APP_GROUP $APP_HOME
acbuild --debug run -- chown -R $APP_USER:$APP_GROUP $APP_ROOT

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

acbuild --debug mount add bridge $APP_ROOT

acbuild --debug copy ./main.sh $APP_BIN/main.sh
acbuild --debug run -- chmod a+x $APP_BIN/main.sh

acbuild --debug set-user $APP_USER
acbuild --debug set-working-directory $APP_ROOT

acbuild --debug environment add APP_HOME $APP_HOME
acbuild --debug environment add APP_BIN $APP_BIN
acbuild --debug environment add HOME $APP_ROOT
# acbuild --debug set-exec -- $APP_BIN/main.sh
acbuild --debug set-exec -- /bin/sh -c "if [ ! -f $APP_ROOT/main.sh ]; then cp $APP_BIN/main.sh $APP_ROOT/; fi && $APP_ROOT/main.sh"

# Save the ACI
acbuild --debug write --overwrite out.aci
