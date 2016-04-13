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

- [Todo API Gateway](https://github.com/scubism/todo_api_gateway.git): API Gateway

```
git clone https://github.com/scubism/todo_api_gateway.git
```

- [Go TODO API](https://github.com/scubism/go_todo_api): A TODO API server written in Go.

```
git clone https://github.com/scubism/go_todo_api.git
```

- [PHP TODO API](https://github.com/scubism/php_todo_api): A TODO API server written in Go.

```
git clone https://github.com/scubism/php_todo_api.git
```

- [React TODO Web](https://github.com/scubism/react_todo_web): A TODO Web client based on react.js framework.

```
git clone https://github.com/scubism/react_todo_web.git
```

### Setup A Host VM

The following will build a VM based on Centos7 with Docker Engin and Docker Compose installed.

```
vagrant up
# For the first time, you should also type the following commands for share folder problem.
vagrant plugin install vagrant-vbguest
vagrant vbguest
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

If you have docker-engine order than 1.10.x, please upgrade it manually by:
```
sudo yum -y install docker-engine
# Upgrade docker-compose to 1.6.2 manually
sudo -i
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
exit
chmod +x /usr/local/bin/docker-compose
```

### Setup Containers For Production

We use Docker Compose to build docker containers by a setting file "docker-compose.yml".

```
# Build a mongodb server which is used by the following go_todo_api server
docker-compose up -d mongo

# Build a mariadb server which is used by the following php_todo_api server
docker-compose up -d mariadb

# Build each microservice respectively
docker-compose up -d go_todo_api
docker-compose up -d php_todo_api
docker-compose up -d react_todo_web

# api_gateway requires the above api services already started
# and need to generate cert files
./todo_api_gateway/scripts/generate_self_certs.sh
# Build API Gateway (Nginx)
docker-compose up -d todo_api_gateway


# Please wait for several minutes for each build
```

Check the container statuses.

```
docker ps -a
```

You can access contents via public endpoints for microservices as follows.

```
curl https://$HOST:$API_GATEWAY_SSL_PORT
curl https://$HOST:$WEB_GATEWAY_SSL_PORT
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
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run -p $GO_TODO_API_PORT:3000 --rm go_todo_api

# alternatively you can login to the container and run the server manually
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run -p $GO_TODO_API_PORT:3000 --rm go_todo_api bash
./docker-entrypoint.sh dev

# if you finished development (left the container), start the production container
docker-compose start go_todo_api
```

For php_todo_api:

```
# stop the production container
docker-compose stop php_todo_api

# run another container for development
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d php_todo_api
docker exec -it php_todo_api bash
./docker-entrypoint.sh

# if you finished development (left the container), start the production container
docker rm -f php_todo_api
docker rmi vagrant_php_todo_api
docker-compose up -d php_todo_api
```

For react_todo_web:

```
# stop the production container
docker-compose stop react_todo_web

# run another container for development
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run -p $REACT_TODO_WEB_PORT:3000 --rm react_todo_web

# alternatively you can login to the container and run the server manually
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run -p $REACT_TODO_WEB_PORT:3000 --rm react_todo_web bash
./docker-entrypoint.sh dev

# if you finished development (left the container), start the production container
docker-compose start react_todo_web
```

Notice that "-f" option specify docker compose setting files which can be overwritten, and "--rm" option will destroy the built container after exit.

For the mongo container, you can access mongodb directory from another mongo container.

```
# Run a mongo container to inspect
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run --rm mongo bash
# Invoke the mongodb client
mongo mongo.vagrant
# Type any mongo command
use go_todo_api
```

For the mariadb container, you can access mariadb directory from another mariadb container.

```
# Run a mariadb container to inspect
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run --rm mariadb bash
# Invoke the mariadb client
mysql -u root -p$DB_PASSWORD $DB_NAME
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
docker-compose up -d go_todo_api
```

#### How to update live container mutably

```
# Update repository in host
cd go_todo_api; git pull origin master; cd ..;
# Copy the repository to container
docker cp go_todo_api $CONTAINER_ID:/tmp
# Enter the container
docker exec -it $CONTAINER_ID bash
# Remove directories except _vendor
find -maxdepth 1 -type d -not -name _vendor -not -name "." -exec rm -irf {} \;
cp -r /tmp/go_todo_api/* ./
rm -rf /tmp/go_todo_api
# (If necessary, execute gom install, gulp build, gulp dist, and etc..)
exit
docker-compose restart go_todo_api
```

## Roadmap

- Create an oauth API with Redis backend
- Create an API gateway with Nginx
- Create a user service
- Create a report service using Elasticsearch and Kibana
- Create a notification service


## License

Released under the MIT License.
