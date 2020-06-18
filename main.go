package main

import (
	"fmt"
	"github.com/docker/docker/api/types"
	iotmakerDocker "github.com/helmutkemper/iotmaker.docker"
	"net/http"
)

func main() {
	http.HandleFunc("/l", HelloServer)
	http.ListenAndServe(":3000", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	var dockerSys = iotmakerDocker.DockerSystem{}
	var list []types.NetworkResource

	var err = dockerSys.Init()
	if err != nil {
		panic(err)
	}

	err, list = dockerSys.NetworkList()
	if err != nil {
		panic(err)
	}

	fmt.Fprintf(w, "%v", list)
}
