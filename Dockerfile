FROM ubuntu:22.04

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl ca-certificates gnupg2 lsb-release fuse libfuse2 apt-transport-https ffmpeg supervisor rclone

COPY . /usr/local/bin/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /media
RUN dpkg -i /usr/local/bin/jellyfin-server.deb /usr/local/bin/jellyfin-web.deb && apt-get -f install
RUN ln -s /usr/share/jellyfin/web/ /usr/lib/jellyfin/bin/jellyfin-web

EXPOSE 8096

CMD ["/usr/bin/supervisord"]