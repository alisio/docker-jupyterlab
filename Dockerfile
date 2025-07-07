# Base image optimized for Python applications
FROM python:3.12-slim

# Metadata
LABEL maintainer="alisio"
LABEL description="Minimal JupyterLab container based on Python 3.12 slim"
LABEL version="1.0"

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    JUPYTER_CONFIG_DIR="/opt/jupyterlab/config" \
    JUPYTER_PORT=8888 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install minimal system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    tini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with specific UID/GID for better compatibility
RUN groupadd -g 1001 jupyter && \
    useradd -u 1001 -g jupyter -m -s /bin/bash jupyter

# Create directories and set permissions
RUN mkdir -p /opt/jupyterlab/{notebooks,config} && \
    chown -R jupyter:jupyter /opt/jupyterlab

# Copy and install Python requirements
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Copy entrypoint script and set permissions
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to non-root user
USER jupyter

# Set working directory
WORKDIR /opt/jupyterlab/notebooks

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${JUPYTER_PORT}/api || exit 1

# Expose port
EXPOSE ${JUPYTER_PORT}

# Use tini as init system for better signal handling
ENTRYPOINT ["tini", "--", "entrypoint.sh"]