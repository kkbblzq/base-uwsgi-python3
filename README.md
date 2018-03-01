# Python3 uWSGI基础镜像

## 镜像说明
本进行镜像配置了以下服务
```
nginx
uWSGI
supervisor
```

## 基础使用
* [Demo](./demo/)  

```
FROM lzq/base-uwsgi-python3:0.1

# 复制应用的nginx配置
COPY demo_app.conf /etc/nginx/conf.d/demo_app.conf

# 安装python程序依赖
COPY ./app/requirements.txt /tmp/requirements.txt
RUN pip install  -r /tmp/requirements.txt --no-cache-dir

# 设置 uwsgi.ini 路径
ENV UWSGI_INI /app/uwsgi.ini

# 设置应用
COPY ./app /app
WORKDIR /app

# 启动应用
CMD ["/usr/bin/supervisord"]
```

### 注1 nginx配置
需要对应用编写一个nginx的vhost配置

例

```
server {
    listen 5015;
    charset utf-8;
    client_max_body_size 75M;
    location / {
        include uwsgi_params;
        uwsgi_pass unix:///var/run/mysite.sock;
    }
}
```

### 注2 基础配置路径(可以自行覆盖)


uWSGI

```
/etc/uwsgi/uwsgi.ini
```

nginx

```
/etc/nginx/nginx.conf
```

supervisor

```
/etc/supervisor.d/supervisord.ini
```