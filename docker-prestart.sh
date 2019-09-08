#!/bin/bash

if [ -e /etc/tls/private/tls.crt ] && [ -e /etc/tls/private/tls.key ]; then
  KEYSTORE_FILE=/config/resources/security/key.p12
  KEYSTORE_PASSWORD="$(dd if=/dev/urandom bs=43 count=1 status=none | base64 -w0)"

  echo "Creating keystore from secret's cert data"
  mkdir -p "$(dirname ${KEYSTORE_FILE})"
  openssl pkcs12 -export -in /etc/tls/private/tls.crt -inkey /etc/tls/private/tls.key -out ${KEYSTORE_FILE} -name localhost -password pass:${KEYSTORE_PASSWORD}
  if [ $? != 0 ]; then
    echo "Failed to create a PKCS12 certificate file with the service-specific certificate. Aborting."
    exit 1;
  fi

  echo "KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD}" >>/config/bootstrap.properties
  echo "<server></server>" >/config/configDropins/defaults/keystore.xml
fi

exec "$@"
