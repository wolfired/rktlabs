# 设置容器运行用户和用户组
acbuild ${ACBUILD_ARGS_DEBUG} set-user $APP_USER
acbuild ${ACBUILD_ARGS_DEBUG} set-group $APP_GROUP

# 映射宿主目录到用户目录
acbuild ${ACBUILD_ARGS_DEBUG} mount add home $USER_HOME

# 设置工作目录
acbuild ${ACBUILD_ARGS_DEBUG} set-working-directory $USER_HOME

# 设置入口脚本
acbuild ${ACBUILD_ARGS_DEBUG} set-exec -- /bin/sh -c "$USER_HOME/$APP_NAME.sh"

# 保存ACI
acbuild ${ACBUILD_ARGS_DEBUG} write --overwrite $APP_PATH/out.aci
