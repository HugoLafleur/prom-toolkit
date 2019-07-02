# Hello Linux Montréal
Here are some of the things we explore during the workshop

### Launch Workspace

See [Launch](https://github.com/HugoLafleur/prom-toolkit#launch).

### Install & Run Node Exporter (locally)
##### Download, Install, Run
Assuming you have `wget`:
```shell
# Get latest releases
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest|jq -r '.assets[].browser_download_url'

# Don't have "jq"? Get latest releases with good ol' grep-n-cut
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest|grep 'browser_download_url' | cut -d\" -f4

RELEASE=0.18.1
TARGET=linux-amd64

wget https://github.com/prometheus/node_exporter/releases/download/v$RELEASE/node_exporter-$RELEASE.$TARGET.tar.gz
tar xvfz node_exporter-$RELEASE.$TARGET.tar.gz && rm node_exporter-$RELEASE.$TARGET.tar.gz
mv node_exporter-$RELEASE.$TARGET node_exporter
./node_exporter/node_exporter > ./node_exporter/node_exporter.log 2>&1 &
```

##### Verify that the exporter is working
```shell
curl http://localhost:9100/metrics
```

##### Stop Node Exporter

```shell
pkill ".*node_exporter.*"
```

### Scrape Metrics

##### Copy jobs from `jobs/` to `../jobs/`, then reload
```shell
cp ./jobs/* ../jobs
cd ..
make reload
```
##### Check Prometheus
  * Configuration
  * Service Discovery
  * Targets

### Query Time Series

##### Check CPU Usage

```
# CPU Time
node_cpu_seconds_total

# CPU Time, excluding 'idle' time
node_cpu_seconds_total{mode!="idle"}

# CPU Utilization (seconds / second), equivalent to CPU Usage %
irate(node_cpu_seconds_total{mode!="idle"}[10s])

# Sum all CPU Usage Modes, by CPU
sum by (cpu) (irate(node_cpu_seconds_total{mode!="idle"}[10s]))

# Same as above, in %
sum by (cpu) (irate(node_cpu_seconds_total{mode!="idle"}[10s])) * 100
```

##### Load the host
```shell
# Create load on the host
dd if=/dev/zero of=/dev/null
```

##### Check Load and CPU Usage
```
# Load
node_load1

# Load for 1, 5 and 15 minutes
{ __name__ =~ "node_load.*" }

# Same as above, without additional labels
sum by (__name__) ({ __name__ =~ "node_load.*" })

# Focus on the loaded CPU
sum by (cpu) (irate(node_cpu_seconds_total{mode!="idle", cpu="1"}[10s])) * 100

# Group by CPU Mode, then stack
sum by (mode) (irate(node_cpu_seconds_total{mode!="idle", cpu="1"}[10s])) * 100
```

### Create Rule
##### Copy rules from `rules/` to `../rules/`, then reload
```shell
cp ./rules/* ../rules
cd ..
make reload
```

### Trigger a CPU Saturation Alert
To create a CPU saturation condition on your host, we're going to start `dd` commands, as many as there are cores on the host.

```shell
# Saturate CPU
load () {
   for i in `seq 1 $(nproc)`
   do
      dd if=/dev/zero of=/dev/null &
   done
}

# Stop
unload () {
   killall dd
}
```

Now, `load` the host, then wait for it...

### Create Dashboard

If you are familiar with Grafana, you may navigate to http://localhost:3000 and create dashboards manually; alternatively, you can use the included dashboards in `./dashboards`:

```shell
cp ./dashboards/* ../grafana/dashboards
```

Grafana's [provisioning feature](https://grafana.com/docs/administration/provisioning/) will pick up on the new dashboards and load them automatically.
