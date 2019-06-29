# Hello Linux Montréal
Here are some of the things we explore during the workshop

### Launch Workspace

See [Launch](https://github.com/HugoLafleur/prom-toolkit#launch).

### Install & Run Node Exporter (locally, on Linux)
##### Download, Install, Run
Assuming you have `wget`:
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvfz node_exporter-0.18.1.linux-amd64.tar.gz && rm node_exporter-0.18.1.linux-amd64.tar.gz
mv node_exporter-0.18.1.linux-amd64 node_exporter
./node_exporter/node_exporter > ./node_exporter/node_exporter.log 2>&1 &
```

##### Verify that the exporter is working
```bash
curl http://localhost:9100/metrics
```

##### Stop Node Exporter

```bash
pkill ".*node_exporter.*"
```

### Scrape Metrics

##### Copy jobs from `jobs/` to `../jobs/`, then reload
```bash
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
```bash
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
```bash
cp ./rules/* ../rules
cd ..
make reload
```

### Trigger a CPU Saturation Alert
To create a CPU saturation condition on your host, duplicate as many `dd` commands below as there are cores on your workspace host. This test was designed for a 2-core host.

```bash
# Aim
load () {
  dd if=/dev/zero of=/dev/null | \
  dd if=/dev/zero of=/dev/null; 
}

# Fire
load
```

To stop, just break with `<Ctrl-C>`.

### Create Dashboard
