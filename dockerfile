FROM golang:alpine3.12 as builder

RUN mkdir /app
RUN chmod 700 /app

COPY . /app

# install git
RUN apk add --no-cache git

# install docker
RUN apk add --update docker openrc
RUN rc-update add docker boot


# install moby project - start

# make libraries folder from git project
RUN mkdir /go/src/github.com
RUN mkdir /go/src/github.com/sirupsen
RUN mkdir /go/src/github.com/pkg
RUN mkdir /go/src/github.com/opencontainers
RUN mkdir /go/src/github.com/gogo
RUN mkdir /go/src/github.com/containerd
RUN mkdir /go/src/github.com/docker

# change dir
WORKDIR /go/src/github.com/docker

# clone moby project
RUN git clone https://github.com/moby/moby.git

# -----------------------------------------------------------------------------
# rename moby to docker
RUN mv moby docker

RUN git clone https://github.com/docker/go-connections.git
RUN git clone https://github.com/docker/distribution.git
RUN git clone https://github.com/docker/go-units.git

WORKDIR /go/src/github.com/Microsoft
RUN git clone https://github.com/Microsoft/go-winio.git

WORKDIR /go/src/github.com/containerd
RUN git clone https://github.com/containerd/containerd.git

WORKDIR /go/src/github.com/gogo
RUN git clone https://github.com/gogo/protobuf.git

WORKDIR /go/src/github.com/opencontainers
RUN git clone https://github.com/opencontainers/go-digest.git
RUN git clone https://github.com/opencontainers/image-spec.git

WORKDIR /go/src/github.com/sirupsen
RUN git clone https://github.com/sirupsen/logrus.git

WORKDIR /go/src/github.com/pkg
RUN git clone https://github.com/pkg/errors.git

RUN go get golang.org/x/sys
RUN go get google.golang.org/grpc/codes

# install moby project - end

# -----------------------------------------------------------------------------
# install iotmaker project - start

RUN mkdir /go/src/github.com/helmutkemper

# change dir
WORKDIR /go/src/github.com/helmutkemper

RUN git clone https://github.com/helmutkemper/iotmaker.docker.git
RUN git clone https://github.com/helmutkemper/iotmaker.docker.util.whaleAquarium.git

# install iotmaker project - end

# remove vendor folder
RUN find . -name vendor -type d -exec rm -rf {} +

# import golang packages to be used inside image "scratch"
ARG CGO_ENABLED=0
RUN go build -o /app/main /app/main.go

# VOLUME /var/run/docker.sock
# VOLUME /app/static/
EXPOSE 3000

CMD ["/app/main"]
