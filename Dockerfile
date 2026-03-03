FROM ghcr.io/openclaw/openclaw:latest

# Switch to root to set up permissions
USER root

# Create entrypoint script that fixes permissions and runs as node user
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "dist/index.js", "gateway"]
