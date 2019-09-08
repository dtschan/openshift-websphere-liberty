FROM websphere-liberty:19.0.0.3-webProfile8

USER root
COPY server.xml /config/
COPY docker-prestart.sh /usr/local/bin/

USER 1001

ENTRYPOINT ["/usr/local/bin/docker-prestart.sh", "/opt/ibm/helpers/runtime/docker-server.sh", "/opt/ibm/wlp/bin/server", "run", "defaultServer"]
