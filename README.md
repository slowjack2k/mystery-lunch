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
* libvips (for image processing)
* ...

### Start app without docker

Make shure mysql is installed and credentials are provided with in the appropriate `.env` file.
Default configs are provided.

```bash
# at the first time
# seeding photos is slow, so you decide SEED_AVATARS true/false
# don't send emails during seeding dev env
> SEED_AVATARS=true MAILHOG="" ./bin/setup
> RAILS_ENV=test bundle exec bin/rails db:create # sometimes need, draw back of current .env config

> ./bin/dev
```

### Start app with docker

First run:

```
>  ./bin/dc-dev build web # just to seed it first handed
> ./bin/dc-dev up
> ./bin/dc-dev exec web -e SEED_AVATARS=true -e MAILHOG="" ./bin/setup # SEED_AVATARS depends on your wishes
> ./bin/dc-dev exec web -e RAILS_ENV=test ./bin/rails db:create
> ./bin/dc-dev exec web bin/docker-dev
```

Subsequent starts:

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

If you want to use a single port & traefik, you have to ensure that all *.localtest.me DNS entries resolve to
127.0.0.1.

Some DNS-Server/Router/OS settings prevent this because of DNS rebind protection. You can try to add *.localtest.me to
the exceptions or use /etc/hosts.

traefik uses the docker socket to get the needed informations from the label 
data of a container. so when you are not using osx, chances are you need to tweak
the traefik volumne mount `- /var/run/docker.sock:/var/run/docker.sock` in
order to get it up & running.


| Action              | traefik url                                                       | plain url                                                | credentials                                                  | 
|---------------------|-------------------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------------|
| Overview            | http://rails.localtest.me:9080/                                   | http://localhost:3000/                                   |                                                              |
| Admin employess     | http://rails.localtest.me:9080/employees                          | http://localhost:3000/employees                          | user/password (can be changed vie .evn files)                |
| Email preview       | http://rails.localtest.me:9080/rails/mailers/participation_mailer | http://localhost:3000/rails/mailers/participation_mailer | -                                                            |
| DB-admin            | http://adminer.localtest.me:9080/                                 | http://localhost:9090                                    | root/password (can be changed via docker-compose.yml)        |
| traefik dashboard   | https://proxy.localtest.me:9083/dashboard/#/                      | -                                                        | admin/admin (can be changed via docker-compose.rubymine.yml) |
| catch all webmailer | http://mailhog.localtest.me:9080/                                 | http://localhost:8025                                    |                                                              |

## Decissions

Be verbose within tests in order to get a better documentation. Against let & co,
prevent [mystery guests](https://thoughtbot.com/blog/mystery-guest).

Moved from features to the "new" system tests in order to have transactional tests during tests within chromium still
available.

array shuffle, ruby uses Fisher-Yates shuffle so it's a good thing

good [old crontab](https://github.com/javan/whenever) is good enough to create new lunches.

`bundle exec whenever --update-crontab --set environment='<RAILS_ENV>'`

`department` is modelled as string and not as enums. At the moment I see not enough advantages for enum.
A string is easier to understand, when you look into the db directly. Further down the road it should
become a model of its own.

Service objects instead of callbacks in order to be more explicit, for this simple app 
the logic could have been placed within the models.

No query objects at the moment, too simple queries. Tried to place all query logic into the models.

`lunch_group` should maybe have been a model of it's own. Until now it's good enough
as string.

Basic auth, it's good enough at the moment, but a little bit hard to use within tests.
