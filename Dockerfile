FROM ubuntu:22.04

# install deps
RUN apt-get update && apt-get install -y curl supervisor && rm -rf /var/lib/apt/lists/*

# -- Blackbox Exporter --
RUN curl -Lo /tmp/blackbox.tar.gz https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-amd64.tar.gz \
 && tar -xzf /tmp/blackbox.tar.gz -C /tmp \
 && mv /tmp/blackbox_exporter-0.24.0.linux-amd64/blackbox_exporter /usr/local/bin/blackbox_exporter

# -- Grafana Agent --
RUN curl -Lo /usr/local/bin/grafana-agent https://github.com/grafana/agent/releases/latest/download/grafana-agent-linux-amd64 \
 && chmod +x /usr/local/bin/grafana-agent

# copy configs
COPY blackbox.yml /etc/blackbox_exporter/blackbox.yml
COPY agent-config.yml /etc/grafana-agent/agent-config.yml
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# expose whatever you need (Blackbox’s port)
EXPOSE 9115

# launch both under supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]