#!/bin/bash

java -jar /opt/fakeSMTP-2.0.jar -b -s -o /opt/mails &
/opt/wildfly/bin/standalone.sh -c standalone-modeshape.xml -b 0.0.0.0 --debug
