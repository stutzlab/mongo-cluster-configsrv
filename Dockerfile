FROM mongo:4.2.8-bionic

RUN apt-get update && apt-get install -y netcat

ENV CONFIG_REPLICA_SET 'configsrv'
ENV CONFIG_SERVER_NODES ''

ADD /startup.sh /
ADD /config.sh /

EXPOSE 27017

CMD [ "/startup.sh" ]

