# Docker tips

## Basic info

Show all images

```
docker images
```

Show all containers

```
docker ps -a
```

Show container logs

```
docker logs $CONTAINER
# Follow log output
docker logs -f $CONTAINER
```

## Basic operations

Build an image

```
docker build -t $TAG .
```

Image tagging

```
docker tag $IMAGE $TAG
```

Remove an image

```
docker rmi $IMAGE
```

Run a container

```
docker-compose up -d $CONTAINER

# Add the `--build` flag to force it to build a new image.
docker-compose up --build -d $CONTAINER
```

Run a instance container with no entrypoint

```
docker-compose run --rm --entrypoint=bash $CONTAINER
```

Login to a running container

```
docker exec -it $CONTAINER bash
```

Remove a container

```
# For stopped containers
docker rm $CONTAINER
# For running containers
docker rm -f $CONTAINER
```

## Removal

Remove all stopped containers

```
docker rm $(docker ps -a -q)
```

Remove all untagged images

```
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
```

## Docker hub

```
docker login
```

```
docker push $IMAGE
```

## Upgrade docker-engine and docker-compose

```
# Upgrade docker-engine
sudo yum -y install docker-engine

# Upgrade docker-compose to 1.7.0 manually
sudo curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
