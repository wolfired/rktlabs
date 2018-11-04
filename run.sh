#!/bin/sh
set -e

RKTLABS_OS=${RKTLABS_OS:-"alpine"}

RKTLABS_APP_NAME=${RKTLABS_APP_NAME:-"playground"}

RKTLABS_APP_USER=${RKTLABS_APP_USER:-"rktlabs"}
RKTLABS_APP_GROUP=${RKTLABS_APP_GROUP:-"rktlabs"}

RKTLABS_APP_USER_HOME=${RKTLABS_APP_USER_HOME:-"/home/$RKTLABS_APP_USER/$RKTLABS_OS/$RKTLABS_APP_NAME"}
RKTLABS_APP_EXTERNAL_DIR=${RKTLABS_APP_EXTERNAL_DIR:-"$RKTLABS_APP_USER_HOME/external"}

mkdir -p /$RKTLABS_APP_EXTERNAL_DIR

rkt --insecure-options=image run --interactive=true `pwd`/$RKTLABS_OS/$RKTLABS_APP_NAME/out.aci \
--hostname=$RKTLABS_APP_NAME --net=host --dns=223.5.5.5 \
--user=$RKTLABS_APP_USER --group=$RKTLABS_APP_GROUP \
--volume external,kind=host,source=/$RKTLABS_APP_EXTERNAL_DIR,readOnly=false
