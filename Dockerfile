FROM corespace/corebase:ubuntu-24.04
LABEL org.opencontainers.image.authors=corebase

RUN apt update && apt install xz-utils sudo unzip -y
RUN deluser ubuntu
RUN useradd -u 1000 factorio

# Preparing and installing factorio
RUN mkdir /server && mkdir /serverfiles
COPY ./init_server.sh /server/init_server.sh
RUN chmod +x /server/init_server.sh

RUN chown -R factorio:factorio /server

EXPOSE 34197/udp

WORKDIR /server
CMD ["bash", "./init_server.sh"]
