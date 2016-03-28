#!/bin/sh

source ./default.env

echo HOST=$HOST
echo GO_TODO_API_PORT=$GO_TODO_API_PORT
echo REACT_TODO_WEB_PORT=$REACT_TODO_WEB_PORT
echo PHP_TODO_API_PORT=$PHP_TODO_API_PORT
echo DB_PASSWORD=$DB_PASSWORD
echo DB_NAME=$DB_NAME

# find and replace
sed -e "s/{{ HOST }}/$HOST/g" \
    -e "s/{{ GO_TODO_API_PORT }}/$GO_TODO_API_PORT/g" \
    -e "s/{{ REACT_TODO_WEB_PORT }}/$REACT_TODO_WEB_PORT/g" \
    -e "s/{{ PHP_TODO_API_PORT }}/$PHP_TODO_API_PORT/g" \
    -e "s/{{ DB_PASSWORD }}/$DB_PASSWORD/g" \
    -e "s/{{ DB_NAME }}/$DB_NAME/g" \
    < docker-compose-template.yml \
    > docker-compose.yml

# For MariaDB
if [ ! -d "/data/mariadb" ]; then
  sudo mkdir -p /data/mariadb/data
  sudo mkdir -p /data/mariadb/conf
fi
