Mosquitto
=========

Docker build file for mosquitto. This docker file is based on
ubuntu 14.4 and mosquitto version 1.4.1 with websocket support enabled

Get it
======
sudo docker pull gzockoll/mosquitto

Run it
======
sudo docker run -p 1883:1883 -p 8080:8080 --name mosquitto -d gzockoll/mosquitto
