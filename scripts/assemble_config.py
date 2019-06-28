#!/usr/bin/env python

import yaml
from getpass import getuser
from glob import glob
from jinja2 import Template

datacenters = yaml.load(
                  Template(
                     open('templates/environment.yml.j2').read()
                  ).render(environment = getuser()))

jobs = list()
for file in glob('jobs/*'):
   tmpl_job = Template(open(file).read())
   jobs.append(tmpl_job.render(datacenters = datacenters, dc = 'local'))

tmpl_prom_config = Template(open('templates/prometheus.yml.j2').read())
prom_config = tmpl_prom_config.render(jobs = jobs)

with open('prometheus/conf/prometheus.yml', 'w') as file_prom_config: 
   file_prom_config.write(prom_config)
   file_prom_config.close()
