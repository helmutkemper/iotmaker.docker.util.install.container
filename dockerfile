FROM golang:alpine3.12 as builder

RUN mkdir /app
RUN chmod 700 /app

COPY . /app

# install git
RUN apk add --no-cache git

RUN go get golang.org/x/sys

# install docker
#RUN apk add --update docker openrc
#RUN rc-update add docker boot

# install moby project - start

# make libraries folder from git project
RUN mkdir /go/src/github.com
RUN mkdir /go/src/github.com/docker

# change dir
WORKDIR /go/src/github.com/docker

# clone moby project
RUN git clone https://github.com/moby/moby.git

# rename moby to docker
RUN mv moby docker
RUN find . -name vendor -type d -exec rm -rf {} +

RUN go get github.com/opencontainers/go-digest
RUN find . -name vendor -type d -exec rm -rf {} +

RUN go get github.com/opencontainers/image-spec/specs-go/v1
RUN find . -name vendor -type d -exec rm -rf {} +

RUN go get github.com/helmutkemper/iotmaker.docker
RUN go get github.com/helmutkemper/iotmaker.docker.util.whaleAquarium/tree/master/v1.0.0
RUN go get github.com/Microsoft/go-winio
RUN go get github.com/containerd/containerd
RUN go get github.com/docker/distribution/reference
RUN go get github.com/docker/go-units
RUN go get github.com/gogo/protobuf/proto
RUN go get github.com/pkg/errors
RUN go get github.com/sirupsen/logrus
RUN go get google.golang.org/grpc/codes
RUN go get github.com/golang/protobuf/proto
RUN go get google.golang.org/genproto/googleapis/rpc/status

# install moby project - end

# remove vendor folder
RUN find . -name vendor -type d -exec rm -rf {} +

# import golang packages to be used inside image "scratch"
ARG CGO_ENABLED=0
RUN go build -o /app/main /app/main.go

# VOLUME /var/run/docker.sock
# VOLUME /app/static/
EXPOSE 3000

CMD ["/app/main"]
