# Deployer Toolkit

A docker image for CI/Build and Deploy

It's A small Alpine image contains (PHP + Deloyer + NODEJS + NPM + YARN + Other CANDYS), Build for CI 

# Tags Instruction

See https://github.com/ihipop/php-nodejs-alpine#tags-instruction for Tags Instruction

[中国大陆优化项](https://github.com/ihipop/deployer-toolkit/blob/master/README_CN.md)

# Usage 
```bash
docker run --rm  -it   -v $(pwd):/project ihipop/deployer-toolkit:php7.1-node8.9-dep6.0 dep --version
```

# PATH & ENV
```bash
COMPOSER_HOME=/usr/local/composer
PATH=/usr/local/composer/vendor/bin/:/project/vendor/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/project
```

