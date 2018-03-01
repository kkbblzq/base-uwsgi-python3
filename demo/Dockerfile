FROM lzq/base-uwsgi-python3:0.1

COPY nginx-custom.conf /etc/nginx/conf.d/nginx.conf
COPY requirements.txt /tmp/requirements.txt
RUN pip install  -r /tmp/requirements.txt --no-cache-dir

ENV UWSGI_INI /app/uwsgi.ini

COPY ./app /app
WORKDIR /app

CMD ["/usr/bin/supervisord"]