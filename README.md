# iotmaker.docker.util.whaleAquarium.sample

Please note: Server image expose folder "/static" and port 3000. 
This code presumes: host computer contains a folder "/static" or "C:/static" and port 
3000 is fre for use.

```golang
var err error
var pullStatusChannel = factoryDocker.NewImagePullStatusChannel()
var networkAutoConfiguration *iotmakerDocker.NextNetworkAutoConfiguration

go func(c chan iotmakerDocker.ContainerPullStatusSendToChannel) {

    for {
        select {
        case status := <-c:
            //fmt.Printf("image pull status: %+v\n", status)

            if status.Closed == true {
                fmt.Println("image pull complete!")
            }
        }
    }

}(*pullStatusChannel)

err, _, networkAutoConfiguration = factoryDocker.NewNetwork("network_delete_before_test")
if err != nil {
    panic(err)
}

err, _, _, _ = NewContainerFromRemoteServerWithNetworkConfiguration(
    "server_delete_before_test:latest",
    "container_delete_before_test",
    iotmakerDocker.KRestartPolicyOnFailure,
    networkAutoConfiguration,
    "https://github.com/helmutkemper/iotmaker.docker.util.whaleAquarium.sample.git",
    []string{},
    pullStatusChannel,
)
if err != nil {
    panic(err)
}

var resp *http.Response
var site []byte
resp, err = http.Get("http://localhost:3000")
if err != nil {
    panic(err)
}

site, err = ioutil.ReadAll(resp.Body)
if err != nil {
    panic(err)
}

err = resp.Body.Close()
if err != nil {
    panic(err)
}

fmt.Printf("%s\n", site)
```