FROM lzq/base-uwsgi-python3:0.1

COPY nginx-custom.conf /etc/nginx/conf.d/nginx.conf

ENV UWSGI_INI /app/uwsgi.ini

COPY ./app /app
WORKDIR /app

CMD ["/usr/bin/supervisord"]