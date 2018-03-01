FROM kkbblzq/base-uwsgi-python3:0.1

LABEL maintainer="lzq <crlzq@vip.qq.com>"

# 复制应用的nginx配置
COPY demo_app.conf /etc/nginx/conf.d/demo_app.conf

# 安装python程序依赖
COPY ./app/requirements.txt /tmp/requirements.txt
RUN pip install  -r /tmp/requirements.txt --no-cache-dir

# 设置 uwsgi.ini 路径
ENV UWSGI_INI /app/uwsgi.ini

# 拷贝应用
COPY ./app /app
WORKDIR /app

# 启动应用
CMD ["/usr/bin/supervisord"]