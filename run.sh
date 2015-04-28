#!/bin/sh

if [ -z "$NO_AUTH" ]; then
  if [ -z "$PASSWORD" ]; then
    PASSWORD=$(pwgen -N 1)
  fi
  touch /etc/mosquitto/users
  mosquitto_passwd -b /etc/mosquitto/users user $PASSWORD
  echo password_file /etc/mosquitto/users >> /etc/mosquitto/mosquitto.conf 
  echo You may login with user:$PASSWORD
fi
mosquitto -c /etc/mosquitto/mosquitto.conf
