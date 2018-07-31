FROM ihipop/php-nodejs-alpine:php7.1-node8.9.npm

LABEL maintainer="ihipop <ihipop#gmail.com>"
LABEL description="(Docker + PHP + Deloyer + NODEJS + NPM + YARN + Other CANDYS) * CI = Deployer Toolkit in Alpine"

#YOU can use `--build-arg IN_CHINA=true` in command line to overwride this VAR
ARG IN_CHINA="false"
ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
ARG http_proxy=""
ARG https_proxy=""
ARG COMPOSER_VERSION=1.6.2
ARG DEPLOYER_VERSION=6.0.5

COPY artifact/local-bin/* /usr/local/bin/

ENV COMPOSER_HOME="/usr/local/composer"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH=${COMPOSER_HOME}/vendor/bin/:/project/vendor/bin/:$PATH
# ENV ENV="/etc/profile"
ARG PHP_EXT_INTERNAL="pdo_mysql mysqli bcmath bz2 zip opcache sockets pcntl gd"
ARG DEL_PKGS_INTERNAL="bzip2-dev libpng-dev libjpeg-turbo-dev freetype-dev pcre-dev"
ARG INSTALL_PKGS_INTERNAL='libbz2 libpng libjpeg-turbo freetype'

RUN [ "$IN_CHINA" == "true" ] && echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/main/' >/etc/apk/repositories \
    && echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/community/' >>/etc/apk/repositories || true

RUN apk add --no-cache \
        openssh-client rsync unzip git bash && \
    echo 'export PATH='${COMPOSER_HOME}/vendor/bin/':/project/vendor/bin/:$PATH' >/etc/profile.d/user_env.sh && \
    echo 'export COMPOSER_HOME='${COMPOSER_HOME} >>/etc/profile.d/user_env.sh


RUN cd /usr/local/bin/ && \
    if [ ! -f /usr/local/bin/composer.phar ];then \
      curl -L https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer.phar; \
    fi && \
    chmod +x /usr/local/bin/composer.phar && \
    ln -s composer.phar composer && \
    curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar -o /usr/local/bin/deployer &&\
    chmod +x /usr/local/bin/deployer &&  ln -s deployer dep && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    if [ ! -f /usr/local/bin/cachetool.phar ];then \
      curl -L https://gordalina.github.io/cachetool/downloads/cachetool.phar -o /usr/local/bin/cachetool.phar; \
    fi && \
    chmod +x /usr/local/bin/cachetool.phar && \
    ln -s cachetool.phar cachetool
    
RUN if [ "$IN_CHINA" == "true" ]; then \
      composer config -g repo.packagist composer https://packagist.laravel-china.org &&\
      npm config set registry https://registry.npm.taobao.org ; \
    fi;

RUN composer global require 'deployer/recipes:<='${DEPLOYER_VERSION} -vv && \
    composer global require "squizlabs/php_codesniffer=*" && \
    npm uninstall -g cnpm && \
    npm install -g cnpm && \
    apk add --no-cache ${INSTALL_PKGS_INTERNAL} ${DEL_PKGS_INTERNAL} && \
    #---------------------------------------
    CPU_NUMBER=$(getconf _NPROCESSORS_ONLN) && \
    if [ $CPU_NUMBER -gt 1 ];then \
        CPU_NUMBER=$((${CPU_NUMBER}-1)); \
    fi && \
    docker-php-ext-install -j${CPU_NUMBER} ${PHP_EXT_INTERNAL} && \
    php -m && \
    #---------------------------------------
    apk del --no-cache ${DEL_PKGS_INTERNAL} && \
    rm -rf /tmp/* /var/cache/apk/* \
    /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts \
    /root/.composer/cache/ ${COMPOSER_HOME}/cache/ /usr/local/php/man/

VOLUME ["/project", "/ssh", "/tmp"]
WORKDIR /project

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--version"]
