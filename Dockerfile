# Stage 1: Pull Blackbox Exporter binary
FROM prom/blackbox-exporter:v0.24.0 as blackbox

# Stage 2: Use official Grafana Agent image
FROM grafana/agent:latest

# Copy Blackbox Exporter binary and config
COPY --from=blackbox /bin/blackbox_exporter /usr/local/bin/blackbox_exporter
COPY blackbox.yml /etc/blackbox_exporter/blackbox.yml

# Copy Grafana Agent config
COPY agent-config.yml /etc/agent/agent-config.yml

# Expose Blackbox port
EXPOSE 9115

# Start both services: Blackbox Exporter and Grafana Agent
CMD ["/bin/sh", "-c", \
  "blackbox_exporter --config.file=/etc/blackbox_exporter/blackbox.yml & \
   exec grafana-agent --config.file=/etc/agent/agent-config.yml"
]