# README

## Dev

Requirements 

* nodejs
* yarn 
* npm

start app

```bash
> foreman  start -f Procfile.dev
```

## Docker

```bash
> docker compose -f docker/docker-compose.yml up
> docker-compose -f docker/docker-compose.yml exec web foreman  start -f Procfile.dev js # why ever it exits
```
DB-Admin: http://localhost:9090/