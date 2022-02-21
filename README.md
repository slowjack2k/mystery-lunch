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

# at the first time
# seeding photos is slow, so you decide SEED_AVATARS true/false
> SEED_AVATARS=true ./bin/rails db:seed
 
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

## URLS

If you want to use a single port & traefik, you have to ensure, that all *.localtest.me DNS entries resolve to
127.0.0.1.

Some DNS-Server/Router/OS settings prevent this because of DNS rebind protection. You can try to add *.localtest.me to
the exceptions or use /etc/hosts.

traefik uses the docker socket to get the needed informations from the label 
data of a container. so when you are not using osx, chances are you need to tweak
the traefik volumne mount `- /var/run/docker.sock:/var/run/docker.sock` in
order to get it up & running.


| Action              | traefik url                                  | plain url                       | credentials                                                  | 
|---------------------|----------------------------------------------|---------------------------------|--------------------------------------------------------------|
| Overview            | http://rails.localtest.me:9080/              | http://localhost:3000/          |                                                              |
| Admin employess     | http://rails.localtest.me:9080/employees     | http://localhost:3000/employees | user/password (can be changed vie .evn files)                |
| DB-admin            | http://adminer.localtest.me:9080/            | http://localhost:9090           | root/password (can be changed via docker-compose.yml)        |
| traefik dashboard   | https://proxy.localtest.me:9083/dashboard/#/ | -                               | admin/admin (can be changed via docker-compose.rubymine.yml) |
| catch all webmailer | http://mailhog.localtest.me:9080/            | http://localhost:8025           |                                                              |

## Decissions

Be verbose within tests in order to get a better documentation. Agains let & co,
Prevent [mystery guests](https://thoughtbot.com/blog/mystery-guest).

Moved from features to the "new" system tests in order to have transactional tests during tests within chromium still
available.

array shuffle, ruby uses Fisher-Yates shuffle so it's a good thing

good [old crontab](https://github.com/javan/whenever) is good enough to create new lunches

`bundle exec whenever --update-crontab --set environment='<RAILS_ENV>'`
