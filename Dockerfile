FROM websphere-liberty:19.0.0.3-webProfile8

ENV JAVA_71_HOME=/opt/IBM/java/java71 \
    ESUM="084369c0c985aa7f6ab67f452e539d15f32ee8db05a91eccfe7a0e7710ee0282"

USER root

# download and install IBM SDK 7.1
RUN apt-get update && apt-get install -y wget && \
    wget -q -U UA_IBM_JAVA_Docker -O /tmp/ibm-java.bin http://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/7.1.4.45/linux/x86_64/ibm-java-sdk-7.1-4.45-x86_64-archive.bin; \
    echo "${ESUM}  /tmp/ibm-java.bin" | sha256sum -c -; \
    echo "INSTALLER_UI=silent" > /tmp/response.properties; \
    echo "USER_INSTALL_DIR=${JAVA_71_HOME}" >> /tmp/response.properties; \
    echo "LICENSE_ACCEPTED=TRUE" >> /tmp/response.properties; \
    cat /tmp/response.properties; \
    mkdir -p $JAVA_71_HOME; \
    chmod +x /tmp/ibm-java.bin; \
    /tmp/ibm-java.bin -i silent -f /tmp/response.properties; \
    rm -f /tmp/ibm-java.bin && \
    chown -R 1001:0 $JAVA_71_HOME && \
    echo -e "\nJAVA_HOME=${JAVA_71_HOME}" >> /config/server.env

COPY server.xml /config/
COPY docker-prestart.sh /usr/local/bin/
RUN chown default /config/* ${JAVA_71_HOME} && chmod g=u /config/* ${JAVA_71_HOME}

USER 1001

ENTRYPOINT ["/usr/local/bin/docker-prestart.sh", "/opt/ibm/helpers/runtime/docker-server.sh", "/opt/ibm/wlp/bin/server", "run", "defaultServer"]
