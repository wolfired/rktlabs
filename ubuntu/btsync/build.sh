. $OS_PATH/acbuild_header.sh

# 安装编译依赖

# 编译

# 清理编译依赖

# 安装运行依赖

# 安装
acbuild ${ACBUILD_ARGS_DEBUG} run -- mkdir -p /build
if [ ! -f ${APP_PATH}/btsync_x64-1.4.111.tar.gz ]; then
    acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- wget https://download-cdn.resilio.com/stable/linux-x64/btsync_x64-1.4.111.tar.gz
else
    acbuild ${ACBUILD_ARGS_DEBUG} copy-to-dir ${APP_PATH}/btsync_x64-1.4.111.tar.gz /build
fi
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- tar -xzf btsync_x64-1.4.111.tar.gz
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- mkdir -p /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/build -- mv btsync /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run -- rm -rf /build

. $OS_PATH/acbuild_footer.sh
