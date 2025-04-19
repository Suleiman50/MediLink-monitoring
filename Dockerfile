# Use the official Blackbox Exporter image
FROM prom/blackbox-exporter:latest

# Copy your probe configuration
COPY blackbox.yml /etc/blackbox_exporter/blackbox.yml

# Expose the default Blackbox port
EXPOSE 9115

# Run Blackbox Exporter with the provided config
ENTRYPOINT ["/bin/blackbox_exporter"]
CMD ["--config.file=/etc/blackbox_exporter/blackbox.yml"]