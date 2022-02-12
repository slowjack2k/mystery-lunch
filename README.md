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
DB-Admin: http://localhost:9090/