package main

import (
	"fmt"
	"github.com/docker/docker/api/types"
	iotmakerDocker "github.com/helmutkemper/iotmaker.docker"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(":3000", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	var dockerSys = iotmakerDocker.DockerSystem{}
	var list []types.NetworkResource

	var err = dockerSys.Init()
	if err != nil {
		log.Fatal(err)
	}

	err, list = dockerSys.NetworkList()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Fprintf(w, "%v", list)
}
