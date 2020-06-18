package main

import (
	iotmakerDocker "github.com/helmutkemper/iotmaker.docker"
	"log"
	"net/http"
)

func main() {

	var dockerSys = iotmakerDocker.DockerSystem{}
	var err = dockerSys.Init()
	if err != nil {
		log.Fatal(err)
	}

	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/", fs)

	err = http.ListenAndServe(":3000", nil)
	if err != nil {
		log.Fatal(err)
	}
}
