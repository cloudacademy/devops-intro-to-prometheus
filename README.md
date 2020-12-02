![icon for Prometheus](prometheus.png)

# Intro-To-Prometheus

This course accompanies the Cloud Academy course 'Intro to Prometheus'

[To the course!](https://www.example.com)

## Don't want to wait around? Neither would I!

### Requirements
- curl
- tar
- bash 
  - tested and validated on bash version 5.0.17(1)-release
- Ports open on localhost
  - 9090 (Prometheus)
  - 8080-8082 (Node Exporters)

If you want to get started with the examples shown in the course, clone this repo, and use the script(s) below to spin up a little prometheus environment with some Node Exporters!

```
curl -LO https://raw.githubusercontent.com/cloudacademy/devops-intro-to-prometheus/main/scripts/letsgo.bash
bash ./letsgo.bash
```

After the Script has completed, feel free to navigate to localhost:{9090,8080,8081,8082} to see all four services started. 

After you're done, don't forget to clean up!

```
curl -LO https://raw.githubusercontent.com/cloudacademy/devops-intro-to-prometheus/tree/main/scripts/cleanup.bash
bash ./cleanup.bash
```


## Checking out the HTTP API - After Prometheus is Started

After the above example is up and running, curl the API to see the nodes

```
curl -g 'http://localhost:9090/api/v1/series?' --data-urlencode 'match[]=up' --data-urlencode 'match[]=process_start_time_seconds{job="prometheus"}'
```
Curl the Label 'job' and the corresponding values

```
curl http://localhost:9090/api/v1/label/job/values
```

## Resources for Prometheus Outside of Cloud Academy

- Websites
  - [Prometheus.io](https://prometheus.io/)
  - [Prometheus Repo](https://github.com/prometheus/prometheus)
- Podcast(s)
  - [Kubernetes Podcast](https://kubernetespodcast.com/episode/037-prometheus-and-openmetrics/)
- Community
  - [Element](https://app.element.io/#/room/#prometheus:matrix.org)
  - [Prometheus Google Group - ANNOUNCEMENTS ONLY](https://groups.google.com/g/prometheus-announce)
  - [Prometheus User Google Group](https://groups.google.com/g/prometheus-users)
  - [Twitter](https://twitter.com/PrometheusIO)