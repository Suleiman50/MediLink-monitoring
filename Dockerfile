# Stage 1: Extract Blackbox Exporter binary
FROM prom/blackbox-exporter:v0.24.0 AS blackbox

# Stage 2: Use official Grafana Agent image (Alpine tag pulls faster)
FROM grafana/agent:latest-alpine

# Blackbox binary + config
COPY --from=blackbox /bin/blackbox_exporter /usr/local/bin/blackbox_exporter
COPY blackbox.yml          /etc/blackbox_exporter/blackbox.yml

# Grafana Agent config
COPY agent-config.yml      /etc/agent/agent-config.yml

EXPOSE 9115

# Use /bin/sh –c … as entrypoint
ENTRYPOINT ["sh", "-c"]

# ONE string ─ will be run by the entrypoint
CMD ["blackbox_exporter --config.file=/etc/blackbox_exporter/blackbox.yml & exec grafana-agent --config.expand-env --config.file=/etc/agent/agent-config.yml"]