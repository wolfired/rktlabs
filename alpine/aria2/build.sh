. $OS_PATH/acbuild_header.sh

# 安装编译依赖

# 编译

# 清理编译依赖

# 安装运行依赖

# 安装
acbuild ${ACBUILD_ARGS_DEBUG} run -- apk add aria2

. $OS_PATH/acbuild_footer.sh
