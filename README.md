# iotmaker.docker.util.whaleAquarium.sample

```golang
package main

import (
  "encoding/json"
  "fmt"
  "github.com/docker/docker/api/types/mount"
  "github.com/docker/go-connections/nat"
  iotmakerDocker "github.com/helmutkemper/iotmaker.docker"
  "github.com/helmutkemper/iotmaker.docker.util.whaleAquarium/v1.0.0/factoryContainerFromRemoteServer"
  whaleAquarium "github.com/helmutkemper/iotmaker.docker.util.whaleAquarium/v1.0.0/factoryContainerMongoDB"
  "github.com/helmutkemper/iotmaker.docker/factoryDocker"
  "io/ioutil"
  "log"
  "net/http"
  "os"
)

func main() {
  var err error
  var pullStatusChannel = factoryDocker.NewImagePullStatusChannel()
  var networkAutoConfiguration *iotmakerDocker.NextNetworkAutoConfiguration

  go func(c chan iotmakerDocker.ContainerPullStatusSendToChannel) {

    for {
      select {
      case status := <-c:
        fmt.Printf("image pull status: %+v\n", status)

        if status.Closed == true {
          fmt.Println("image pull complete!")
        }
      }
    }

  }(*pullStatusChannel)

  err, _, networkAutoConfiguration = factoryDocker.NewNetwork(
    "network_delete_before_test",
  )
  if err != nil {
    panic(err)
  }

  err, _, _ = factoryContainerFromRemoteServer.NewContainerFromRemoteServerChangeExposedPortAndVolumes(
    "delete:latest",
    "delete",
    "https://github.com/helmutkemper/lixo.git",
    []string{},
    []nat.Port{
      "3000/tcp",
    },
    []nat.Port{
      "3000/tcp",
    },
    []mount.Mount{
      {
        Type: "bind",
        Source: "//var/run/docker.sock",
        Target: "/var/run/docker.sock",
      },
    },
    pullStatusChannel,
  )
  if err != nil {
    panic(err)
  }



  os.Exit(0)
  // address: 10.0.0.2
  err, _, _ = whaleAquarium.NewSingleEphemeralInstanceMongoWithNetworkConfigurationAndWithoutPort(
    "container_a_delete_before_test",
    iotmakerDocker.KRestartPolicyOnFailure,
    networkAutoConfiguration,
    whaleAquarium.KMongoDBVersionTag_3,
    pullStatusChannel,
  )
  if err != nil {
    panic(err)
  }

  // address: 10.0.0.3
  err, _, _ = whaleAquarium.NewSingleEphemeralInstanceMongoWithNetworkConfigurationAndWithoutPort(
    "container_b_delete_before_test",
    iotmakerDocker.KRestartPolicyOnFailure,
    networkAutoConfiguration,
    whaleAquarium.KMongoDBVersionTag_3,
    pullStatusChannel,
  )
  if err != nil {
    panic(err)
  }

  // address: 10.0.0.4
  err, _, _ = whaleAquarium.NewSingleEphemeralInstanceMongoWithNetworkConfigurationAndWithoutPort(
    "container_c_delete_before_test",
    iotmakerDocker.KRestartPolicyOnFailure,
    networkAutoConfiguration,
    whaleAquarium.KMongoDBVersionTag_3,
    pullStatusChannel,
  )
  if err != nil {
    panic(err)
  }

  // address: 10.0.0.5:8080
  err, _, _, _ = factoryContainerFromRemoteServer.NewContainerFromRemoteServerWithNetworkConfiguration(
    "image_server_delete_before_test:latest",
    "cont_server_delete_before_test",
    iotmakerDocker.KRestartPolicyUnlessStopped,
    networkAutoConfiguration,
    "https://github.com/helmutkemper/iotmaker.docker.util.whaleAquarium.mongodb.test.git",
    []string{},
    pullStatusChannel,
  )
  if err != nil {
    panic(err)
  }

  verifyServer("http://127.0.0.1:8080/?db=10.0.0.2:27017")
  verifyServer("http://127.0.0.1:8080/?db=10.0.0.3:27017")
  verifyServer("http://127.0.0.1:8080/?db=10.0.0.4:27017")

  // Output:
  // image pull complete!
  // image pull complete!
  // image pull complete!
  // map[error: ok:true]
  // map[error: ok:true]
  // map[error: ok:true]
}

func verifyServer(url string) {
  var err error
  var serverReader *http.Response
  var serverResponse []byte
  var dataToOutput interface{}

  serverReader, err = http.Get(url)
  if err != nil {
    log.Printf("http server get error: %v", err.Error())
    return
  }

  serverResponse, err = ioutil.ReadAll(serverReader.Body)
  if err != nil {
    log.Printf("http server readAll error: %v", err.Error())
    return
  }

  err = json.Unmarshal(serverResponse, &dataToOutput)
  if err != nil {
    log.Printf("http server json unmarshal error: %v", err.Error())
    return
  }

  fmt.Printf("%v\n", dataToOutput)
}
```

docker run --rm -d alpine:latest tail -f /dev/null
docker exec -it d7605c8 sh


docker run --rm --name test -d golang:alpine3.12 tail -f /dev/null
docker exec -it test sh
