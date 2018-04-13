FROM alpine:3.6

LABEL maintainer="lzq <crlzq@vip.qq.com>"

ENV PYPY_VERSION 5.10.1

ENV PYTHON_PIP_VERSION 9.0.1

ENV PATH /usr/local/bin:$PATH
# 更换系统软件源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 时区设置
RUN apk add --no-cache tzdata ca-certificates libressl tcl tk dpkg
ENV TZ Asia/Shanghai

RUN set -ex; \
    \
    # this "case" statement is generated via "update.sh"
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    # amd64
    amd64) pypyArch='linux64'; sha256='75a276e1ee1863967bbacb70c5bff636de200768c0ec90e72f7ec17aace0aefe' ;; \
    # arm32v5
    armel) pypyArch='linux-armel'; sha256='5065e9ad958d06b9612ba974f43997d20168d4245c054dd43270e4b458782282' ;; \
    # i386
    i386) pypyArch='linux32'; sha256='a6ceca9ee5dc511de7902164464b88311fec9366c5673d0c00528eda862bbe54' ;; \
    *) echo >&2 "error: current architecture ($dpkgArch) does not have a corresponding PyPy $PYPY_VERSION binary release"; exit 1 ;; \
    esac; \
    \
    wget -O pypy.tar.bz2 "https://bitbucket.org/pypy/pypy/downloads/pypy3-v${PYPY_VERSION}-${pypyArch}.tar.bz2"; \
    echo "$sha256 *pypy.tar.bz2" | sha256sum -c; \
    tar -xjC /usr/local --strip-components=1 -f pypy.tar.bz2; \
    rm pypy.tar.bz2; \
    \
    pypy3 --version

RUN set -ex; \
    \
    wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
    \
    pypy3 get-pip.py \
    --disable-pip-version-check \
    --no-cache-dir \
    "pip==$PYTHON_PIP_VERSION" \
    ; \
    pip --version; \
    \
    rm -f get-pip.py

# 设置pip镜像
RUN mkdir -p ~/.pip && echo -e "[global]\ntimeout = 6000\nindex-url = https://pypi.doubanio.com/simple\n[install]\nuse-mirrors = true\nmirrors = https://pypi.doubanio.com/simple\ntrusted-host = pypi.doubanio.com" > ~/.pip/pip.conf



# 安装基础环境
RUN apk add --no-cache gcc g++ make libc-dev mariadb-dev postgresql-dev python-dev pcre-dev jpeg-dev

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

# 安装supervisor
RUN apk add --no-cache supervisor

# 配置supervisor
COPY supervisord.ini /etc/supervisor.d/supervisord.ini