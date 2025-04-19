# Stage 1: Blackbox Exporter binary
FROM prom/blackbox-exporter:v0.24.0 AS blackbox

# Stage 2: Grafana Agent (Debian base, ~200 MB compressed)
# pick a specific version; v0.40.2 is the most recent stable today
FROM grafana/agent:v0.40.2

# --- copy binaries & configs ---
COPY --from=blackbox /bin/blackbox_exporter /usr/local/bin/blackbox_exporter
COPY blackbox.yml      /etc/blackbox_exporter/blackbox.yml
COPY agent-config.yml  /etc/agent/agent-config.yml

EXPOSE 9115

ENTRYPOINT ["sh", "-c"]
CMD ["blackbox_exporter --config.file=/etc/blackbox_exporter/blackbox.yml & exec grafana-agent --config.expand-env --config.file=/etc/agent/agent-config.yml"]