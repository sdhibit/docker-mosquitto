FROM jleight/phusion-python:2.7
MAINTAINER Steve Hibit <sdhibit@gmail.com>

RUN set -x \
 && apt-get update \
 && apt-get install -y \
    build-essential \
    libc-ares-dev \
    libssl-dev \
    libwebsockets-dev \
    libwrap0-dev \
    pwgen  \
    uuid-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

ENV APP_SOURCE /usr/local/src
ENV APP_DATA /var/mosquitto
ENV APP_CONFIG /etc/mosquitto
ENV APP_VERSION 1.4.2
ENV APP_BASE_URL http://mosquitto.org/files/source
ENV APP_PKGNAME mosquitto-${APP_VERSION}
ENV APP_URL ${APP_BASE_URL}/${APP_PKGNAME}.tar.gz

# Download and compile Mosquitto
RUN set -x \
 && groupadd -r -g 300 mosquitto \
 && useradd -r -u 300 -g mosquitto mosquitto \
 && mkdir -p "${APP_SOURCE}" "${APP_DATA}" "${APP_CONFIG}" \
 && mkdir -p /etc/defaults/mosquitto/ \
 && curl -kL "${APP_URL}" | tar -xz -C "${APP_SOURCE}" \
 && sed -i 's/WITH_WEBSOCKETS:=no/WITH_WEBSOCKETS:=yes/' \
    "${APP_SOURCE}"/"${APP_PKGNAME}"/config.mk \
 && cd "${APP_SOURCE}"/"${APP_PKGNAME}" \
 && make \
 && make install \
 && ldconfig \
 && chown -R mosquitto:mosquitto "${APP_DATA}" "${APP_CONFIG}" \
 && rm -rf "${APP_SOURCE}"/"${APP_PKGNAME}" 

ADD mosquitto.conf /etc/defaults/mosquitto/
ADD mosquitto-service.sh /etc/service/mosquitto/run

EXPOSE 1883 8080 8883
VOLUME ["${APP_CONFIG}", "${APP_DATA}"]
