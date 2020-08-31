FROM mongo:4.4.0-bionic

RUN apt-get update && apt-get install -y netcat inetutils-ping

ENV CONFIG_REPLICA_SET 'configsrv'
ENV INIT_CONFIG_NODES ''
ENV CLUSTER_SHARED_KEY ''
ENV WIRED_TIGER_CACHE_SIZE_GB ''

ADD /startup.sh /
ADD /health.sh /
ADD /config.sh /

VOLUME [ "/data" ]

EXPOSE 27017

CMD [ "/startup.sh" ]

