# Use a minimal Ubuntu base
FROM ubuntu:22.04

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      tar \
      supervisor && \
    rm -rf /var/lib/apt/lists/*

# Install Blackbox Exporter
RUN curl -fsSL -o /tmp/blackbox.tar.gz \
      https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-amd64.tar.gz && \
    tar -xzf /tmp/blackbox.tar.gz -C /tmp && \
    mv /tmp/blackbox_exporter-0.24.0.linux-amd64/blackbox_exporter /usr/local/bin/blackbox_exporter && \
    rm -rf /tmp/blackbox*

# Install Grafana Agent
RUN curl -fsSL -o /usr/local/bin/grafana-agent \
      https://github.com/grafana/agent/releases/latest/download/grafana-agent-linux-amd64 && \
    chmod +x /usr/local/bin/grafana-agent

# Create config directories
RUN mkdir -p /etc/blackbox_exporter /etc/grafana-agent /etc/supervisor

# Copy configuration files
COPY blackbox.yml /etc/blackbox_exporter/blackbox.yml
COPY agent-config.yml /etc/grafana-agent/agent-config.yml
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Expose Blackbox’s port
EXPOSE 9115

# Launch supervisord (which will start both exporters)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]