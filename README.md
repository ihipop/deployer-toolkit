# Deployer Toolkit

A docker image for CI/Build and Deploy

It's A small Alpine image contains (PHP + Deloyer + NODEJS + NPM + YARN + Other CANDYS), Build for CI 

# Tags Instruction

See https://github.com/ihipop/php-nodejs-alpine#tags-instruction for Tags Instruction

[中国大陆优化项](https://github.com/ihipop/deployer-toolkit/blob/master/README_CN.md)

# Usage 
```bash
docker run --rm  -it  -v $(pwd):/project ihipop/deployer-toolkit:php7.1-node8.9-dep6.0 dep --version
docker run --rm  -it  -v $(pwd):/project ihipop/deployer-toolkit:php7.1-node8.9-dep6.0 composer --version
docker run --rm  -it  -v $(pwd):/project ihipop/deployer-toolkit:php7.1-node8.9-dep6.0 npm --version
#....
```

# PATH & ENV
```bash
COMPOSER_HOME=/usr/local/composer
PATH=/usr/local/composer/vendor/bin/:/project/vendor/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/project
```

## SSH KEY for deploy files with access to remote host
- `DEPLOY_SSH_KEY_FILE` Private SSH  as a file, will be pass to `ssh-add`
- `DEPLOY_SSH_KEY_BASE64` Private SSH key's content with base64 ecnoded, will be pass to `ssh-add` after decoded
-  `DEPLOY_SSH_KEY` Private SSH key's Content, will be pass to `ssh-add`

# Globally Installed Apps/Integrated
- [Deployer (With `deployer/recipes` installed)](https://deployer.org)
- [Composer](https://getcomposer.org)
- [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- [CacheTool](http://gordalina.github.io/cachetool/)
- NODEJS + NPM + YARN family
- Necessary binary DEV libs for NPM Build in CI
- Glibc
# Mount Point
> `/ssh` 

None hidden files in `/ssh` will be **copy** to `$HOME/.ssh`  and set by `chmod 600` in docker container.

> `/project`

Is mount as current working dir.

> `/tmp` 

Is just mount as `/tmp`

# PHP

## Module in Default

> php -m

```
[PHP Modules]
bcmath
bz2
Core
ctype
curl
date
dom
fileinfo
filter
ftp
hash
iconv
json
libxml
mbstring
mysqli
mysqlnd
openssl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
Reflection
session
SimpleXML
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
zip
zlib

[Zend Modules]

```