. $OS_PATH/acbuild_header.sh

# 安装编译依赖
acbuild ${ACBUILD_ARGS_DEBUG} run -- apk --no-cache --virtual build-dependendencies add git make gcc g++ libtool boost-dev build-base openssl-dev openssl zlib-dev

# 编译
REPO_NAME=${REPO_NAME:-"i2pd"}
REPO_URL=${REPO_URL:-"https://github.com/PurpleI2P/i2pd.git"}
GIT_BRANCH=${GIT_BRANCH:-"-b openssl"}
GIT_TAG=${GIT_TAG:-""}

LABS_ROOT=${LABS_ROOT:-"/rktlabs"}
DATA_ROOT=${DATA_ROOT:-"/rktdata"}

acbuild ${ACBUILD_ARGS_DEBUG} run -- mkdir -p $LABS_ROOT

acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT -- git clone $GIT_BRANCH $REPO_URL
if [ -n "${GIT_TAG}" ]; then
    acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME -- git checkout tags/${GIT_TAG}
fi

acbuild ${ACBUILD_ARGS_DEBUG} run -- mkdir -p $DATA_ROOT
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME -- cp -R contrib/certificates $DATA_ROOT
acbuild ${ACBUILD_ARGS_DEBUG} run -- chown -R $APP_USER:$APP_GROUP $DATA_ROOT

acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME -- make

acbuild ${ACBUILD_ARGS_DEBUG} run -- mkdir -p /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME -- cp i2pd /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=/usr/local/bin -- strip i2pd

acbuild ${ACBUILD_ARGS_DEBUG} run -- rm -rf $LABS_ROOT

# 清理编译依赖
acbuild ${ACBUILD_ARGS_DEBUG} run -- apk --no-cache --purge del build-dependendencies

# 安装运行依赖
acbuild ${ACBUILD_ARGS_DEBUG} run -- apk --no-cache add boost-filesystem boost-system boost-program_options boost-date_time boost-thread boost-iostreams openssl musl-utils libstdc++

# 安装

. $OS_PATH/acbuild_footer.sh
