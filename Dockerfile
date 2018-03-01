FROM hub.dianchu.cc/library/python:3-alpine

LABEL maintainer="crlzq@vip.qq.com"

RUN pip install uwsgi --no-cache-dir

COPY uwsgi.ini /etc/uwsgi/

# install nginx
RUN apk add --no-cache nginx

COPY nginx.conf /etc/nginx/nginx.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN apk add --no-cache supervisor

COPY supervisord.ini /etc/supervisor.d/supervisord.ini