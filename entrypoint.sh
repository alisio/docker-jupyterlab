#!/bin/bash
set -e

# Install additional Python packages if PIP_PACKAGES is set
if [ ! -z "$PIP_PACKAGES" ]; then
    echo "Installing additional packages: $PIP_PACKAGES"
    pip install --no-cache-dir $PIP_PACKAGES
fi

# Start JupyterLab with better configuration
exec jupyter lab \
    --ip=0.0.0.0 \
    --port=${JUPYTER_PORT} \
    --no-browser \
    --allow-root \
    --notebook-dir=/opt/jupyterlab/notebooks \
    --ServerApp.token='' \
    --ServerApp.password='' \
    --ServerApp.disable_check_xsrf=True
