SHELL := /bin/bash
PROMETHEUS_VERSION ?= latest
ALERTMANAGER_VERSION ?= latest
GRAFANA_VERSION ?= latest

configure:
	@echo "Creating Virtual Environment"
	@mkdir -p conf jobs rules
	@ls work > /dev/null 2>&1 || \
		( \
			virtualenv -p python3 work; \
			source work/bin/activate; \
			pip install -r requirements.txt; \
		)

clean:
	@echo "Cleaning up"
	@echo "...removing virtualenv"
	@rm -rf ./work
	@rm -rf ./conf/prometheus.yml

assemble-config:
	@echo "Assembling Prometheus configuration file"
	@( \
		source work/bin/activate; \
		./scripts/assemble_config.py; \
	)

build: assemble-config

workspace: configure build
	@echo "Starting environment..."
	@docker-compose down
	@docker-compose up -d

reload: assemble-config
	@echo "Reloading Prometheus configuration"
	@curl -XPOST http://localhost:9090/-/reload
	@echo "Reloading Alertmanager configuration"
	@curl -XPOST http://localhost:9093/-/reload

destroy: clean
	@echo "...destroying local environment"
	@rm -rf work
	@docker-compose down
	@echo -n "Pruning images: "; docker image prune --force
	@echo -n "Pruning volumes: "; docker volume prune --force
	@docker image ls --format '{{ .ID }},{{ .Repository }}:{{ .Tag }}' \
		| egrep "prometheus:local|alertmanager:local|grafana:local" | cut -d, -f1 | uniq | xargs docker image rm --force \
		|| echo Already clean
