#!/bin/sh
set -e

REPO_NAME=${REPO_NAME:-"i2pd"}
REPO_URL=${REPO_URL:-"https://github.com/PurpleI2P/$REPO_NAME.git"}
GIT_BRANCH=${GIT_BRANCH:-"openssl"}
GIT_TAG=${GIT_TAG:-""}

USER_NAME=${USER_NAME:-"i2pd"}
I2PD_HOME=${I2PD_HOME:-"/home/$USER_NAME"}
DATA_DIR=${DATA_DIR:-"$I2PD_HOME/data"}

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# Start the build with an empty ACI
acbuild --debug begin ./alpine_latest.aci

# In the event of the script exiting, end the build
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

# Name the ACI
acbuild --debug set-name wolfired.com/i2pd

#
acbuild --debug run -- mkdir -p "$I2PD_HOME" "$I2PD_HOME"/bin "$DATA_DIR"
acbuild --debug run -- adduser -S -h "$I2PD_HOME" "$USER_NAME"
acbuild --debug run -- chown -R "$USER_NAME":nobody "$I2PD_HOME"

#
acbuild --debug run -- /bin/sh -c "echo 'https://mirrors.ustc.edu.cn/alpine/latest-stable/main' > /etc/apk/repositories"
acbuild --debug run -- /bin/sh -c "echo 'https://mirrors.ustc.edu.cn/alpine/latest-stable/community' >> /etc/apk/repositories"
acbuild --debug run -- apk update

#
acbuild --debug run -- apk --no-cache --virtual build-dependendencies add make gcc g++ libtool boost-dev build-base openssl-dev openssl git
#acbuild --debug run -- apk --no-cache --virtual build-dependendencies add git
acbuild --debug run -- mkdir -p /build
acbuild --debug run --working-dir=/build -- git clone -b $GIT_BRANCH $REPO_URL
if [ -n "${GIT_TAG}" ]; then
    acbuild --debug run --working-dir=/build/$REPO_NAME -- git checkout tags/${GIT_TAG}
fi
acbuild --debug run --working-dir=/build/$REPO_NAME -- make
acbuild --debug run --working-dir=/build/$REPO_NAME -- cp -R contrib/certificates $I2PD_HOME
acbuild --debug run --working-dir=/build/$REPO_NAME -- mv i2pd $I2PD_HOME/bin
acbuild --debug run -- strip $I2PD_HOME/bin/i2pd
acbuild --debug run -- rm -rf /build

acbuild --debug run -- apk --no-cache --purge del build-dependendencies build-base fortify-headers boost-dev zlib-dev openssl-dev \
boost-python3 python3 gdbm boost-unit_test_framework boost-python linux-headers boost-prg_exec_monitor \
boost-serialization boost-signals boost-wave boost-wserialization boost-math boost-graph boost-regex git pcre \
libtool g++ gcc pkgconfig

acbuild --debug run -- apk --no-cache add boost-filesystem boost-system boost-program_options boost-date_time boost-thread boost-iostreams openssl musl-utils libstdc++

acbuild --debug mount add i2pd-data $DATA_DIR

acbuild --debug copy ./main.sh $I2PD_HOME/bin/main.sh
acbuild --debug run -- chmod a+x $I2PD_HOME/bin/main.sh

acbuild --debug environment add I2PD_HOME $I2PD_HOME
acbuild --debug environment add DATA_DIR $DATA_DIR
acbuild --debug set-exec -- $I2PD_HOME/bin/main.sh

# Save the ACI
acbuild --debug write --overwrite alpine_i2pd.aci
