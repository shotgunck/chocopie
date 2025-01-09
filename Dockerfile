FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests curl gnupg2 ca-certificates lsb-release fuse apt-transport-https ffmpeg supervisor rclone && \
    curl -fsSL https://repo.jellyfin.org/jellyfin_team.gpg.key | gpg --dearmor -o /usr/share/keyrings/jellyfin-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/jellyfin-keyring.gpg] https://repo.jellyfin.org/ubuntu jammy main" > /etc/apt/sources.list.d/jellyfin.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests jellyfin-server jellyfin-web && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt && apt-get clean && \
    ln -s /usr/share/jellyfin/web/ /usr/lib/jellyfin/bin/jellyfin-web && \
    mkdir -p /media

COPY rclone.conf /usr/local/bin/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8096

CMD ["/usr/bin/supervisord"]
