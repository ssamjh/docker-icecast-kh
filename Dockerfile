FROM alpine:latest

# Based on the Dockerfile for moul/icecast by Manfred Touron <m@42.am>
# Updated by ssamjh
MAINTAINER ssamjh <sam@samhowell.nz

ENV IC_VERSION "2.4.0-kh16"

RUN apk update && \
    apk add build-base wget curl libxml2-dev libxslt-dev \
        libogg-dev libvorbis-dev libtheora-dev \
        speex py3-pip && \
    wget "https://github.com/karlheyes/icecast-kh/archive/icecast-$IC_VERSION.tar.gz" -O- | tar zxvf - && \
    cd "icecast-kh-icecast-$IC_VERSION" && \
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var && \
    make && make install && adduser -D icecast && \
    chown -R icecast /etc/icecast.xml


RUN pip3 install supervisor supervisor-stdout

ADD ./start.sh /start.sh
ADD ./etc /etc

CMD ["/start.sh"]
EXPOSE 8000
VOLUME ["/config", "/var/log/icecast"]
