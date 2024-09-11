FROM websphere-liberty

USER root
RUN mkdir /opt/oracle-driver
COPY ojdbc6-11.2.0.4.jar /opt/oracle-driver/

USER 1001
ARG NOME_PACOTE=

COPY --chown=1001:0  server.xml /config/
RUN sed -i "s/@@NOME_PACOTE@@/${NOME_PACOTE}/g" /config/server.xml
COPY --chown=1001:0  jvm.options /config/

COPY --chown=1001:0  ${NOME_PACOTE} /config/dropins/

RUN configure.sh