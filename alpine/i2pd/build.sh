. $OS_PATH/acbuild_header.sh

# 安装编译依赖
acbuild --debug run -- apk --no-cache --virtual build-dependendencies add make gcc g++ libtool boost-dev build-base openssl-dev openssl git zlib-dev

# 编译
REPO_NAME=${REPO_NAME:-"i2pd"}
REPO_URL=${REPO_URL:-"https://github.com/PurpleI2P/i2pd.git"}
GIT_BRANCH=${GIT_BRANCH:-"openssl"}
GIT_TAG=${GIT_TAG:-""}

acbuild --debug run -- mkdir -p /build
acbuild --debug run --working-dir=/build -- git clone -b $GIT_BRANCH $REPO_URL
if [ -n "${GIT_TAG}" ]; then
    acbuild --debug run --working-dir=/build/$REPO_NAME -- git checkout tags/${GIT_TAG}
fi
acbuild --debug run -- mkdir -p /i2pd
acbuild --debug run --working-dir=/build/$REPO_NAME -- cp -R contrib/certificates /i2pd
acbuild --debug run -- chown -R $APP_USER:$APP_GROUP /i2pd
acbuild --debug run --working-dir=/build/$REPO_NAME -- make
acbuild --debug run --working-dir=/build/$REPO_NAME -- mkdir -p /usr/local/bin
acbuild --debug run --working-dir=/build/$REPO_NAME -- mv i2pd /usr/local/bin
acbuild --debug run --working-dir=/usr/local/bin -- strip i2pd
acbuild --debug run -- rm -rf /build

# 清理编译依赖
acbuild --debug run -- apk --no-cache --purge del build-dependendencies

# 安装运行依赖
acbuild --debug run -- apk --no-cache add boost-filesystem boost-system boost-program_options boost-date_time boost-thread boost-iostreams openssl musl-utils libstdc++

# 安装

. $OS_PATH/acbuild_footer.sh
