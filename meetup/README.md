# Hello Linux Montréal
Here are some of the things we explore during the workshop

### Start Workspace

See https://github.com/HugoLafleur/prom-toolkit.

### Install & Start Node Exporter (locally, on Linux)
Assuming you have `wget`:
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvfz node_exporter-0.18.1.linux-amd64.tar.gz && rm node_exporter-0.18.1.linux-amd64.tar.gz
mv node_exporter-0.18.1.linux-amd64 node_exporter
./node_exporter/node_exporter > ./node_exporter/node_exporter.log 2>&1 &
```

Stop Node Exporter:

```bash
pkill ".*node_exporter.*"
```

### Scrape Metrics

### Query Time Series

### Create Rule

### CPU Saturation Alert

### Create Dashboard
