FROM hub.dianchu.cc/library/python:3-alpine

LABEL maintainer="crlzq@vip.qq.com"

RUN apk add --no-cache gcc g++ make

RUN apk add --no-cache --virtual .build-deps linux-headers && \
    pip install uwsgi --no-cache-dir && \
    apk del .build-deps && \
    find /usr/local -depth \
    \(\
    \( -type d -a \( -name test -o -name tests \) \) \
    -o \
    \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
    \) -exec rm -rf '{}' +

RUN pip install uwsgi --no-cache-dir

COPY uwsgi.ini /etc/uwsgi/

# install nginx
RUN apk add --no-cache nginx

COPY nginx.conf /etc/nginx/nginx.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN apk add --no-cache supervisor

COPY supervisord.ini /etc/supervisor.d/supervisord.ini