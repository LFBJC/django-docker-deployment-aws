#!/bin/sh

set -e

# replaces the values for the variables, for instance ${LISTEN_PORT} will be replaced by the number of the port
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'