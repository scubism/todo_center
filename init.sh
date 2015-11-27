#!/bin/sh

source ./default.env

echo LOCALIP=$LOCALIP
echo GO_TODO_API_PORT=$GO_TODO_API_PORT
echo REACT_TODO_WEB_PORT=$REACT_TODO_WEB_PORT

# find and replace
sed -e "s/{{ LOCALIP }}/$LOCALIP/g" \
    -e "s/{{ GO_TODO_API_PORT }}/$GO_TODO_API_PORT/g" \
      -e "s/{{ REACT_TODO_WEB_PORT }}/$REACT_TODO_WEB_PORT/g" \
    < docker-compose-template.yml \
    > docker-compose.yml
