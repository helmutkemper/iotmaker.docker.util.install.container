FROM golang:alpine3.12 as builder

RUN mkdir /app
RUN chmod 700 /app

COPY . /app

RUN apk add --no-cache git

RUN mkdir /go/src/github.com
RUN mkdir /go/src/github.com/docker

WORKDIR /go/src/github.com/docker

RUN git clone https://github.com/moby/moby.git
RUN mv moby docker

# RUN apk add --update docker openrc
# RUN rc-update add docker boot

# RUN go get -u github.com/helmutkemper/iotmaker.docker

# RUN find . -name vendor -type d -exec rm -rf {} +

# import golang packages to be used inside image "scratch"
ARG CGO_ENABLED=0
RUN go build -o /app/main /app/main.go

# VOLUME /var/run/docker.sock
# VOLUME /app/static/
EXPOSE 3000

CMD ["/app/main"]
