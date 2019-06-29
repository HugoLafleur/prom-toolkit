# Grafana, Prometheus & Alertmanager: A toolkit

## What it is
A local framework to develop Prometheus & Alertmanager configurations (rules, jobs, receivers, routes, etc.).

## What it is not
A repository for jobs, rules, receivers and route fragments. See recommended workflow below.

## Hello Linux Montréal !
Also, includes the [material](https://github.com/HugoLafleur/prom-toolkit/tree/master/meetup) used at the Linux Meetup (Montreal) on August 6 2019.

## Getting Started
### Requirements (suggested)

0. Linux (tested successfully with Ubuntu 18.04)
1. Docker CE >= v17.x
2. Docker Compose >= v1.21.x
3. Virtualenv >= 15.x.x
4. Python 3.x.x
5. AWS CLI >= 1.10

_*Note for MacOS users*: Most of the commands will run on a station with Docker for Desktop, but some of the networking assumptions do not apply for MacOS (e.g. reaching the host machine from the gateway in the Docker bridge network). Added a macos-specific scraping job to address this._

### Launch
To start the workspace, just use:

```bash
make workspace
```

### Reload
Once you've made changes, you may reload the configuration to update the workspace.
```bash
make reload
```

## Recommended Workflow
Here's how you should use this:

1. Develop **jobs** and/or **rules** locally by creating job files in valid YAML format under `jobs/` and `rules/`, respectively.
2. Launch or Reload (this will assemble a `prometheus.yml` file and start the workspace)

## Important Notes

**<!>** _Be mindful of networking, e.g. a job that works locally may or may not work when promoted due to networking differences between local and live environments._
