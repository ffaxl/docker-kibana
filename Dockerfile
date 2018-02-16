FROM ubuntu:latest
MAINTAINER Evgeniy Slizevich <evgeniy@slizevich.net>

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* \
    && addgroup --system kibana \
    && adduser --gecos '&' --shell /bin/bash --ingroup kibana --system kibana \
    && mkdir /kibana \
    && wget -qO - `wget -qO - https://www.elastic.co/downloads/kibana | grep -Eo 'https://.*?/kibana-.*?-linux-x86_64.tar.gz' | head -1` | tar xzf - --strip-components=1 -C /kibana \
    && sed -i 's|^#*elasticsearch.url: .*$|elasticsearch.url: "http://elasticsearch:9200"|g' /kibana/config/kibana.yml \
    && sed -i 's|^#*server.host: .*$|server.host: 0.0.0.0|g' /kibana/config/kibana.yml \
    && mv /kibana/config /kibana/config.orig \
    && mkdir /kibana/config \
    && chown -R kibana:kibana /kibana

COPY entry /

EXPOSE 5601

VOLUME /kibana/config

ENTRYPOINT /entry
