# TODO Center

# THIS PROJECT IS A SAMPLE PROTOTYPE TO BUILD MICROSERVICES

TODO Center is a central repository for a complete TODO app which is composed of distributed microservices.

## Installation

### Clone Repositories

Clone this repository and enter the directory.

```
git clone https://github.com/scubism/todo_center.git
cd todo_center
```

Then, clone each repository which provide a respective microservice.

- [Go TODO API](https://github.com/scubism/go_todo_api): A TODO API server written in Go.

```
git clone https://github.com/scubism/go_todo_api.git
```

- [React TODO Web](https://github.com/scubism/react_todo_web): A TODO Web client based on react.js framework.

```
git clone https://github.com/scubism/react_todo_web.git
```

### Setup A Host VM

The following will build a VM based on Centos7 with Docker Engin and Docker Compose installed.

```
vagrant up
# Please wait for several minutes
# Use "vagrant suspend" and "vagrant resume" on your machine restart.
```

Login to the VM.

```
vagrant ssh
# Now you are in /vagrant directory (not in /home/vagrant directory).
```

For the first time or environment changed, execute a init file.

```
./init.sh
# This will create a docker-compose.yml file from the environment.
```

### Setup Containers For Production

We use Docker Compose to build docker containers by a setting file "docker-compose.yml".

```
# Build a mongodb server which is used by the following go_todo_api server
docker-compose --x-networking up -d mongo

# Build each microservice respectively
docker-compose --x-networking up -d go_todo_api
docker-compose --x-networking up -d react_todo_web

# Please wait for several minutes for each build
```

Notice that "--x-networking" option enables [Docker Networking](http://docs.docker.com/engine/userguide/networking/dockernetworks/).

Check the container statuses.

```
docker ps -a
```

You can access contents via public endpoints for microservices as follows.

```
curl http://$HOST:$GO_TODO_API_PORT
curl http://$HOST:$REACT_TODO_WEB_PORT
# Here, the variables such as $HOST are defined in default.env
```

Check the urls on your browser too.

### Setup Containers For Development

The above containers are immutable for production.
Thus for development, we should run a mutable container beside the original.

For go_todo_api:

```
# stop the production container
docker-compose stop go_todo_api

# run another container for development
docker-compose --x-networking -f docker-compose.yml -f docker-compose.dev.yml run -p $GO_TODO_API_PORT:3000 --rm go_todo_api

# alternatively you can login to the container and run the server manually
docker-compose --x-networking -f docker-compose.yml -f docker-compose.dev.yml run -p $GO_TODO_API_PORT:3000 --rm go_todo_api bash
./docker-entrypoint.sh dev

# if you finished development (left the container), start the production container
docker-compose start go_todo_api
```


For react_todo_web:

```
# stop the production container
docker-compose stop react_todo_web

# run another container for development
docker-compose --x-networking -f docker-compose.yml -f docker-compose.dev.yml run -p $REACT_TODO_WEB_PORT:3000 --rm react_todo_web

# alternatively you can login to the container and run the server manually
docker-compose --x-networking -f docker-compose.yml -f docker-compose.dev.yml run -p $REACT_TODO_WEB_PORT:3000 --rm react_todo_web bash
./docker-entrypoint.sh dev

# if you finished development (left the container), start the production container
docker-compose start react_todo_web
```

Notice that "-f" option specify docker compose setting files which can be overwritten, and "--rm" option will destroy the built container after exit.

For the mongo container, you can access mongodb directory from another mongo container.

```
# Run a mongo container to inspect
docker-compose --x-networking -f docker-compose.yml -f docker-compose.dev.yml run --rm mongo bash
# Invoke the mongodb client
mongo mongo.vagrant
# Type any mongo command
use go_todo_api
```

#### How to recreate the production image?

If you had developed your app, you need to update the production image.
You can recreate the image from local cache as below.

```
# Rename the old image (preserve the image)
docker tag vagrant_go_todo_api vagrant_go_todo_api_1
docker rmi vagrant_go_todo_api
# (Note that the prefix "vagrant_" will be changed to the top directory name)
# Build the new image
docker-compose --x-networking up -d go_todo_api
```

## Roadmap

- Create an oauth API with Redis backend
- Create an API gateway with Nginx
- Create a user service
- Create a report service using Elasticsearch and Kibana
- Create a notification service


## License

Released under the MIT License.
