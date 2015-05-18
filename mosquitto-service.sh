#!/bin/sh

CONFIG_FILE=/etc/mosquitto/mosquitto.conf

if [ -f "$CONFIG_FILE" ]; then
  echo "mosquitto config found"
else
  echo "mosquitto config not found. creating default config."
  cp /etc/defaults/mosquitto/mosquitto.conf $CONFIG_FILE
  chown mosquitto:mosquitto $CONFIG_FILE
fi

if [ -z "$NO_AUTH" ]; then
  if [ -z "$PASSWORD" ]; then
    PASSWORD=$(pwgen -N 1)
  fi
  touch /etc/mosquitto/users
  mosquitto_passwd -b /etc/mosquitto/users user $PASSWORD
  echo password_file /etc/mosquitto/users >> /etc/mosquitto/mosquitto.conf 
  echo You may login with user:$PASSWORD
fi
/sbin/setuser mosquitto mosquitto -c /etc/mosquitto/mosquitto.conf
