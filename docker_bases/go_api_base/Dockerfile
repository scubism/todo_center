FROM golang:1.6-alpine

# Install git for package download, bash for better shell
RUN apk --no-cache add git bash

# Install go package manager
RUN go get github.com/tools/godep

RUN go get github.com/gin-gonic/gin \
  && go get github.com/itsjamie/gin-cors \
  && go get gopkg.in/mgo.v2 \
  && go get github.com/pborman/uuid \
  && go get golang.org/x/crypto/bcrypt
