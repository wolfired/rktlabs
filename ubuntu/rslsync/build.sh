. $OS_PATH/acbuild_header.sh

# 安装编译依赖

# 编译

# 清理编译依赖

# 安装运行依赖

# 安装
acbuild ${ACBUILD_ARGS_DEBUG} run -- mkdir -p /build
if [ ! -f ${APP_PATH}/resilio-sync_x64.tar.gz ]; then
    acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- wget https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz
else
    acbuild ${ACBUILD_ARGS_DEBUG} copy-to-dir ${APP_PATH}/resilio-sync_x64.tar.gz /build
fi
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- tar -xzf resilio-sync_x64.tar.gz
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- mkdir -p /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- mv rslsync /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run -- rm -rf /build

. $OS_PATH/acbuild_footer.sh
