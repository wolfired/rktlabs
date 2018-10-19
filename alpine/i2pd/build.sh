#!/bin/sh
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

APP_ID=${APP_ID:-"wolfired.com"}

APP_NAME=`pwd`
APP_NAME=${APP_NAME##*/}

APP_USER=${APP_USER:-"i2pd"}
DIR_HOME=${DIR_HOME:-"/home/$APP_USER"}
DIR_BIN=${DIR_BIN:-"$DIR_HOME/bin"}
DIR_DATA=${DIR_DATA:-"$DIR_HOME/data"}

REPO_NAME=${REPO_NAME:-"i2pd"}
REPO_URL=${REPO_URL:-"https://github.com/PurpleI2P/i2pd.git"}
GIT_BRANCH=${GIT_BRANCH:-"openssl"}
GIT_TAG=${GIT_TAG:-""}

# Start the build with an empty ACI
acbuild --debug begin ../alpine-latest.aci

# In the event of the script exiting, end the build
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

# Name the ACI
acbuild --debug set-name $APP_ID/$APP_NAME

#
acbuild --debug run -- mkdir -p $DIR_BIN $DIR_DATA
acbuild --debug run -- addgroup -S $APP_USER
acbuild --debug run -- adduser -S -h $DIR_HOME -G $APP_USER $APP_USER
acbuild --debug run -- chown -R $APP_USER:$APP_USER $DIR_HOME

#
acbuild --debug run -- /bin/sh -c "echo 'https://mirrors.ustc.edu.cn/alpine/latest-stable/main' > /etc/apk/repositories"
acbuild --debug run -- /bin/sh -c "echo 'https://mirrors.ustc.edu.cn/alpine/latest-stable/community' >> /etc/apk/repositories"
acbuild --debug run -- apk update

#
acbuild --debug run -- apk --no-cache --virtual build-dependendencies add make gcc g++ libtool boost-dev build-base openssl-dev openssl git
acbuild --debug run -- mkdir -p /build
acbuild --debug run --working-dir=/build -- git clone -b $GIT_BRANCH $REPO_URL
if [ -n "${GIT_TAG}" ]; then
    acbuild --debug run --working-dir=/build/$REPO_NAME -- git checkout tags/${GIT_TAG}
fi
acbuild --debug run --working-dir=/build/$REPO_NAME -- make
acbuild --debug run --working-dir=/build/$REPO_NAME -- cp -R contrib/certificates $DIR_HOME
acbuild --debug run --working-dir=/build/$REPO_NAME -- mv i2pd $DIR_BIN
acbuild --debug run -- strip $DIR_BIN/i2pd
acbuild --debug run -- rm -rf /build

acbuild --debug run -- apk --no-cache --purge build-dependendencies del build-base fortify-headers boost-dev zlib-dev openssl-dev \
boost-python3 python3 gdbm boost-unit_test_framework boost-python linux-headers boost-prg_exec_monitor \
boost-serialization boost-signals boost-wave boost-wserialization boost-math boost-graph boost-regex git pcre \
libtool g++ gcc pkgconfig

acbuild --debug run -- apk --no-cache add boost-filesystem boost-system boost-program_options boost-date_time boost-thread boost-iostreams openssl musl-utils libstdc++

acbuild --debug mount add data $DIR_DATA

acbuild --debug copy ./main.sh $DIR_BIN/main.sh
acbuild --debug run -- chmod a+x $DIR_BIN/main.sh

acbuild --debug set-user $APP_USER

acbuild --debug environment add DIR_HOME $DIR_HOME
acbuild --debug environment add DIR_BIN $DIR_BIN
acbuild --debug environment add DIR_DATA $DIR_DATA
acbuild --debug set-exec -- $DIR_BIN/main.sh

# Save the ACI
acbuild --debug write --overwrite out.aci
