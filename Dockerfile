FROM alpine:latest

# 环境变量
ENV LANG="C.UTF-8" \
    TZ="Asia/Shanghai" \
    NGINX_PORT="8091" \
    NGINX_SSL_PORT="8095" \
    REPO_URL="https://github.com/chen3861229/embyExternalUrl" \
    SSL_ENABLE="false" \
    SSL_CRON="0 /2   " \
    SSL_DOMAIN="" \
    AUTO_UPDATE="false" \
    SERVER="emby"

# 安装git
RUN apk --no-cache add nginx nginx-mod-http-js curl tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo "$TZ" > /etc/timezone && \
    mkdir -p /var/cache/nginx/emby/image /opt && \
    apk --no-cache add git && \
    git clone $REPO_URL /embyExternalUrl && \
    apk del git && \
    rm -rf /var/cache/apk/*

COPY entrypoint /entrypoint
COPY start_server /start_server
COPY check_certificate /check_certificate
COPY config/logrotate.conf /etc/logrotate.d/medialinker

RUN chmod +x /entrypoint /start_server /check_certificate

ENTRYPOINT ["/bin/sh", "/entrypoint"]
