APP_NAME=${APP_PATH##*/}
APP_ID=${APP_ID:-"wolfired.com/$APP_NAME"}

APP_USER=${APP_USER:-${SUDO_USER}}
APP_USER_ID=${APP_USER_ID:-`id ${SUDO_USER} -u`}
APP_GROUP=${APP_GROUP:-`id ${SUDO_USER} -gn`}
APP_GROUP_ID=${APP_GROUP_ID:-`id ${SUDO_USER} -g`}

USER_HOME=${USER_HOME:-"/home/$APP_USER"}

# 准备初始容器
[ ! -f $OS_PATH/base.aci ] && docker2aci docker://alpine && mv ./library-alpine-latest.aci $OS_PATH/base.aci && chown $APP_USER:$APP_GROUP $OS_PATH/base.aci

# 开始构建ACI
acbuild ${ACBUILD_ARGS_DEBUG} begin $OS_PATH/base.aci

# 退出脚本前, 结束构建ACI
trap "{ export EXT=$?; acbuild ${ACBUILD_ARGS_DEBUG} end && exit $EXT; }" EXIT

# 命名ACI
acbuild ${ACBUILD_ARGS_DEBUG} set-name $APP_ID

# 创建目录与用户
acbuild ${ACBUILD_ARGS_DEBUG} run -- mkdir -p $USER_HOME
acbuild ${ACBUILD_ARGS_DEBUG} run -- addgroup -S -g $APP_GROUP_ID $APP_GROUP
acbuild ${ACBUILD_ARGS_DEBUG} run -- adduser -S -h $USER_HOME -G $APP_GROUP -u $APP_USER_ID $APP_USER
acbuild ${ACBUILD_ARGS_DEBUG} run -- chown -R $APP_USER:$APP_GROUP $USER_HOME

# 更新系统
acbuild ${ACBUILD_ARGS_DEBUG} run -- sed -i "s@http://dl-cdn.alpinelinux.org/@https://mirrors.huaweicloud.com/@g" /etc/apk/repositories
acbuild ${ACBUILD_ARGS_DEBUG} run -- apk update
acbuild ${ACBUILD_ARGS_DEBUG} run -- apk upgrade

# 设置系统时间
acbuild ${ACBUILD_ARGS_DEBUG} run -- apk add tzdata
acbuild ${ACBUILD_ARGS_DEBUG} run -- ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
acbuild ${ACBUILD_ARGS_DEBUG} run -- touch /etc/timezone
acbuild ${ACBUILD_ARGS_DEBUG} run -- /bin/sh -c "echo 'Asia/Shanghai' > /etc/timezone"
