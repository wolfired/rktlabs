set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

APP_ID=${APP_ID:-"wolfired.com"}

APP_NAME=`pwd`
APP_NAME=${APP_NAME##*/}

APP_USER=${APP_USER:-"rktlabs"}
DIR_HOME=${DIR_HOME:-"/home/$APP_USER"}
DIR_BIN=${DIR_BIN:-"$DIR_HOME/bin"}
DIR_DATA=${DIR_DATA:-"$DIR_HOME/data"}

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

acbuild --debug mount add data $DIR_DATA

acbuild --debug copy ./main.sh $DIR_BIN/main.sh
acbuild --debug run -- chmod a+x $DIR_BIN/main.sh

acbuild --debug set-user $APP_USER

acbuild --debug environment add DIR_DATA $DIR_DATA
acbuild --debug set-exec -- $DIR_BIN/main.sh

# Save the ACI
acbuild --debug write --overwrite out.aci
