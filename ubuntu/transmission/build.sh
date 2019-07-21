. $OS_PATH/acbuild_header.sh

# 安装编译依赖
acbuild ${ACBUILD_ARGS_DEBUG} run -- apt-get -y install git cmake libssl-dev build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev

# 编译
REPO_NAME=${REPO_NAME:-"transmission"}
REPO_URL=${REPO_URL:-"https://github.com/transmission/transmission"}
GIT_BRANCH=${GIT_BRANCH:-""}
GIT_TAG=${GIT_TAG:-""}

LABS_ROOT=${LABS_ROOT:-"/rktlabs"}
DATA_ROOT=${DATA_ROOT:-"/rktdata"}

acbuild ${ACBUILD_ARGS_DEBUG} run -- mkdir -p $LABS_ROOT

acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT -- git clone $GIT_BRANCH $REPO_URL
if [ -n "${GIT_TAG}" ]; then
    acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME -- git checkout tags/${GIT_TAG}
fi

acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME -- git submodule update --init
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME -- mkdir build
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME/build -- cmake -DENABLE_GTK=OFF -DENABLE_QT=OFF -DENABLE_MAC=OFF -DENABLE_UTILS=OFF -DENABLE_CLI=OFF -DENABLE_TESTS=OFF -DENABLE_NLS=OFF -DINSTALL_DOC=OFF -DINSTALL_LIB=OFF ..
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME/build -- make

acbuild ${ACBUILD_ARGS_DEBUG} run  -- mkdir -p /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run --working-dir=$LABS_ROOT/$REPO_NAME/build -- cp ./daemon/transmission-daemon /usr/local/bin
acbuild ${ACBUILD_ARGS_DEBUG} run -- rm -rf $LABS_ROOT

# 清理编译依赖
acbuild ${ACBUILD_ARGS_DEBUG} run -- apt-get -y autoremove git cmake libssl-dev build-essential automake autoconf libtool pkg-config intltool libcurl4-openssl-dev libglib2.0-dev libevent-dev libminiupnpc-dev libgtk-3-dev libappindicator3-dev
acbuild ${ACBUILD_ARGS_DEBUG} run -- apt-get -y autoclean

# 安装运行依赖
acbuild ${ACBUILD_ARGS_DEBUG} run -- apt-get -y install libssl1.1 libevent-2.1-6 libcurl4 libminiupnpc10

# 安装

. $OS_PATH/acbuild_footer.sh
