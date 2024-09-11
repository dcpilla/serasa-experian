#!/bin/sh
if [ ! -z "$JMX_ENABLED" ]; then
  echo JMX enabled
  java -jar -Dcom.sun.management.jmxremote \
  -Dcom.sun.management.jmxremote.port=9010 \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.rmi.port=9010 \
  -Dcom.sun.management.jmxremote.local.only=false \
  -Djava.rmi.server.hostname=localhost\
  -jar /app/app.jar
else
  java -jar /app/app.jar
fi
