FROM pypy:3-slim

LABEL maintainer="lzq <crlzq@vip.qq.com>"

ENV PYPY_VERSION 5.10.1

ENV PYTHON_PIP_VERSION 9.0.1

ENV PATH /usr/local/bin:$PATH

# 时区设置
RUN apt-get update && \
    apt-get install -y tzdata ca-certificates gcc g++ make libc-dev libpq-dev python-dev libpcre3 libpcre3-dev libjpeg-dev build-essential nginx supervisor
ENV TZ Asia/Shanghai

# 设置pip镜像
RUN mkdir -p ~/.pip && echo -e "[global]\ntimeout = 6000\nindex-url = https://pypi.doubanio.com/simple\n[install]\nuse-mirrors = true\nmirrors = https://pypi.doubanio.com/simple\ntrusted-host = pypi.doubanio.com" > ~/.pip/pip.conf

# 安装uwsgi
RUN pip install uwsgi

# 复制基础uwsgi配置
COPY uwsgi.ini /etc/uwsgi/uwsgi.ini 

# 复制nginx基础配置
COPY nginx.conf /etc/nginx/nginx.conf

# 配置supervisor
COPY app.conf /etc/supervisor/conf.d/