FROM golang:alpine3.12 as builder

RUN mkdir /app
RUN chmod 700 /app

COPY . /app

# make libraries folder from git project
RUN mkdir /go/src/github.com
RUN mkdir /go/src/github.com/docker

# change dir
WORKDIR /go/src/github.com/docker

RUN RUN apk update && apk add --no-cache wget
RUN wget https://github.com/moby/moby/archive/v19.03.11.tar.gz
RUN tar -xzf v19.03.11.tar.gz && rm v19.03.11.tar.gz


WORKDIR /
RUN find . -name vendor -type d -exec rm -rf {} +

CMD ["sh", "-c", "tail -f /dev/null"]
