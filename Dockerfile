FROM hub.dianchu.cc/library/python:3-alpine

LABEL maintainer="lzq <crlzq@vip.qq.com>"

# 安装uwsgi基础编译环境
RUN apk add --no-cache gcc g++ make

# 安装uwsgi
RUN apk add --no-cache --virtual .build-deps linux-headers && \
    pip install uwsgi --no-cache-dir && \
    apk del .build-deps

# 复制基础uwsgi配置
COPY uwsgi.ini /etc/uwsgi/uwsgi.ini

# 安装nginx
RUN apk add --no-cache nginx

# 复制nginx基础配置
COPY nginx.conf /etc/nginx/nginx.conf

# 设置nginx前台运行
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# 安装supervisor
RUN apk add --no-cache supervisor

# 配置supervisor
COPY supervisord.ini /etc/supervisor.d/supervisord.ini