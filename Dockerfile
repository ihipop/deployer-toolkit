FROM ihipop/php-nodejs-alpine:php7.1-node8.9

LABEL maintainer="ihipop <ihipop#gmail.com>"
LABEL description="(Docker + PHP + Deloyer + NODEJS + NPM + YARN + Other CANDYS) * CI = Deployer Toolkit in Alpine"

#YOU can use `--build-arg IN_CHINA=true` in command line to overwride this VAR
ARG IN_CHINA="false"
ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
ARG COMPOSER_VERSION=1.6.2
ARG DEPLOYER_VERSION=6.0.5

ARG ARTIFACT=/tmp/artifact
COPY artifact ${ARTIFACT}

ENV COMPOSER_HOME="/usr/local/composer" 
ENV PATH=${COMPOSER_HOME}/vendor/bin/:/project/vendor/bin/:$PATH
# ENV ENV="/etc/profile"

RUN [ "$IN_CHINA" == "true" ] && echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/main/' >/etc/apk/repositories \
    && echo 'http://mirrors.ustc.edu.cn/alpine/v3.4/community/' >>/etc/apk/repositories || true

RUN apk update --no-cache \
    && apk add --no-cache \
        openssh-client rsync unzip git bash && \
    echo 'export PATH='${COMPOSER_HOME}/vendor/bin/':/project/vendor/bin/:$PATH' >/etc/profile.d/user_env.sh && \
    echo 'export COMPOSER_HOME='${COMPOSER_HOME} >>/etc/profile.d/user_env.sh


RUN if [ -f "${ARTIFACT}"/composer.phar ];then \
      mv "${ARTIFACT}"/composer.phar /usr/local/bin/composer; \
    else \
      curl -L https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer; \
    fi && \
    chmod +x /usr/local/bin/composer && \
    curl -L https://deployer.org/releases/v$DEPLOYER_VERSION/deployer.phar -o /usr/local/bin/deployer &&\
    chmod +x /usr/local/bin/deployer &&  ln -s deployer dep && mv ./dep /usr/local/bin/  && \
    mv "${ARTIFACT}"/entrypoint.sh /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    if [ -f "${ARTIFACT}"/cachetool.phar ];then \
      mv "${ARTIFACT}"/cachetool.phar /usr/local/bin/cachetool; \
    else \
      curl -L https://gordalina.github.io/cachetool/downloads/cachetool.phar -o /usr/local/bin/cachetool; \
    fi && \
    chmod +x /usr/local/bin/cachetool && \
    rm -rf "${ARTIFACT}" 

RUN if [ "$IN_CHINA" == "true" ]; then \
      composer config -g repo.packagist composer https://packagist.laravel-china.org &&\
      npm config set registry https://registry.npm.taobao.org ; \
    fi;

RUN composer global require 'deployer/recipes:<='${DEPLOYER_VERSION} && \
    composer global require "squizlabs/php_codesniffer=*" && \
    npm uninstall -g cnpm && \
    npm install -g cnpm && \
    rm -rf /tmp/* /var/cache/apk/* \
    /root/.npm /root/.node-gyp /root/.gnupg /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts \
    /root/.composer/cache/ ${COMPOSER_HOME}/cache/

VOLUME ["/project", "/root/.ssh", "/tmp"]
WORKDIR /project

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--version"]
