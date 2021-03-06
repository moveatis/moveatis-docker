#!/bin/bash

JBOSS_HOME=/opt/wildfly
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE="standalone"
JBOSS_CONFIG=$JBOSS_MODE-modeshape.xml

function wait_for_wildfly() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

echo "==> Starting WildFly..."
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c $JBOSS_CONFIG &

echo "==> Waiting..."
wait_for_wildfly

echo "==> Executing..."
echo "Runnind datasource.cli"
$JBOSS_CLI -c --file=`dirname "$0"`/datasource.cli
$JBOSS_HOME/bin/add-user.sh -a admin admin 

echo "==> Shutting down WildFly..."
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi
