FROM golang:alpine3.12 as builder

RUN mkdir /app
RUN chmod 700 /app

COPY . /app

# install git
RUN apk add --no-cache git

RUN go get godoc.org/golang.org/x/sys/windows; exit 0

# install docker
RUN apk add --update docker openrc
RUN rc-update add docker boot

# install moby project - start

# make libraries folder from git project
RUN mkdir /go/src/github.com
RUN mkdir /go/src/github.com/docker

# change dir
WORKDIR /go/src/github.com/docker

RUN go get github.com/helmutkemper/iotmaker.docker; exit 0
RUN go get github.com/helmutkemper/iotmaker.docker.util.whaleAquarium/tree/master/v1.0.0; exit 0
RUN go get github.com/Microsoft/go-winio; exit 0
RUN go get github.com/docker/distribution/reference; exit 0
RUN go get github.com/docker/go-units; exit 0
RUN go get github.com/gogo/protobuf/proto; exit 0
RUN go get github.com/pkg/errors; exit 0
RUN go get github.com/sirupsen/logrus; exit 0
RUN go get google.golang.org/grpc/codes; exit 0
RUN go get github.com/golang/protobuf/proto; exit 0
RUN go get google.golang.org/genproto/googleapis/rpc/status; exit 0
RUN go get github.com/containerd/containerd; exit 0
RUN go get github.com/opencontainers/image-spec/specs-go/v1; exit 0
RUN go get github.com/opencontainers/go-digest; exit 0

# clone moby project
RUN git clone https://github.com/moby/moby.git

# rename moby to docker
RUN mv moby docker

WORKDIR /
RUN find . -name vendor -type d -exec rm -rf {} +

# install moby project - end

# import golang packages to be used inside image "scratch"
ARG CGO_ENABLED=0
RUN go build -o /app/main /app/main.go

# VOLUME /var/run/docker.sock
# VOLUME /app/static/
EXPOSE 3000

CMD ["/app/main"]
