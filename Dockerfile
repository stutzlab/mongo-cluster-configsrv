FROM mongo:4.4.0-bionic

RUN apt-get update && apt-get install -y netcat

ENV CONFIG_REPLICA_SET 'configsrv'
ENV INIT_CONFIG_NODES ''

ADD /startup.sh /
ADD /health.sh /
ADD /config.sh /

HEALTHCHECK --start-period=30s --retries=3 CMD [ "/health.sh" ]

VOLUME [ "/data" ]

EXPOSE 27017

CMD [ "/startup.sh" ]

