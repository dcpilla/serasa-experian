FROM websphere-liberty

ARG NOME_PACOTE=

COPY --chown=1001:0  server.xml /config/

COPY --chown=1001:0  ${NOME_PACOTE} /config/dropins/

RUN configure.sh