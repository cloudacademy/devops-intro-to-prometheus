#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS='linux'
elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS='darwin'
fi

curl -LO https://github.com/prometheus/prometheus/releases/download/v2.22.2/prometheus-2.22.2.$OS-amd64.tar.gz
tar xzvf prometheus-2.22.2.$OS-amd64.tar.gz
cd prometheus-2.22.2.$OS-amd64

cat <<'EOF' >./prometheus.yml
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'CloudAcademy-Prom-Demo'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:9090']
EOF

echo "Starting Prometheus..."

# Start Prometheus.
# By default, Prometheus stores its database in ./data (flag --storage.tsdb.path).
./prometheus --config.file=prometheus.yml&


echo "Prometheus is started, navigate to localhost:9090 for UI or to localhost:9090/metrics for the RAW Prometheus metrics."

echo "Grabbing node_exporters..."

curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.$OS-amd64.tar.gz
tar zxvf node_exporter-1.0.1.$OS-amd64.tar.gz
cd node_exporter-1.0.1.$OS-amd64

echo "Starting Loopback node_exporters on 8080 8081 8082"

./node_exporter --web.listen-address 127.0.0.1:8080&
sleep 1
./node_exporter --web.listen-address 127.0.0.1:8081&
sleep 1
./node_exporter --web.listen-address 127.0.0.1:8082&

echo "Altering Prometheus.yml..."

cd ..

cat <<'EOF' >>./prometheus.yml
  - job_name: 'Prom1-node'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:8080', 'localhost:8081']
        labels:
          group: 'CloudAcademy-Prod'

      - targets: ['localhost:8082']
        labels:
          group: 'CloudAcademy-Dev'
EOF

echo "Creating prometheus.rules.yml"

cat <<'EOF' >./prometheus.rules.yml
groups:
- name: cpu-node
  rules:
  - record: job_instance_mode:node_cpu_seconds:avg_rate5m
    expr: avg by (job, instance, mode) (rate(node_cpu_seconds_total[5m]))
EOF

echo "Adding rule statement to prometheus.yml"

cat <<'EOF' >>./prometheus.yml
rule_files:
  - 'prometheus.rules.yml'
EOF
sleep 2

echo "Restarting Prometheus to apply config changes"

pkill prometheus
./prometheus --config.file=prometheus.yml&

sleep 1

echo "
------------------------------------------------------------------------------------------------------
        All Done! Several Node Exporters are started and Prometheus is scraping itself.
                         Navigate to localhost:9090 and play around!
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
        WHEN YOU'RE DONE, DON'T FORGET TO CLEAN UP WITH THE CLEANUP SCRIPT (cleanup.bash)
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
"