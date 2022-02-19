# README

## Dev

Requirements 

* ruby 2.7.5
* bundler
* nodejs
* yarn 
* npm
* mysql
* optional docker


start app

```bash
> ./bin/setup
> ./bin/dev
```

## Docker

```bash
# create env / start existing one
> ./bin/dc-dev up
# destroy env
> ./bin/dc-dev down
# start the dev system
> ./bin/dc-dev exec web bin/docker-dev
# shell
> ./bin/dc-dev exec web bash
```

For rubymine integration:

https://www.jetbrains.com/help/ruby/using-docker-compose-as-a-remote-interpreter.html#debug_with_docker_compose

By issues with displaying files within the container with `sh`
based images https://youtrack.jetbrains.com/issue/IDEA-244173

DB-Admin: http://localhost:9090/

## OSX & mysql

```
> gem install mysql2 -- --with-mysql-dir=$(brew --prefix mysql-client)
```

or

~/.bundle/config
```yaml
---
BUNDLE_BUILD__MYSQL2: "--with-mysql-dir=/usr/local/opt/mysql-client"
```

## Decissions

Be verbose within tests in order to get a better documentation.
Agains let & co, Prevent [mystery guests](https://thoughtbot.com/blog/mystery-guest).


Moved from features to the "new" system tests in order to have transactional tests during tests within chromium still available.

array shuffle, ruby uses Fisher-Yates shuffle so it's a good thing

