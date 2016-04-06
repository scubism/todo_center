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
```

Run a instance container with no entrypoint

```
docker-compose run --rm --entrypoint=bash todo_api_gateway
```

Login to a running container

```
docker exec -it $CONTAINER bash
```

Remove a running container

```
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
