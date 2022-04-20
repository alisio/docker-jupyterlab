FROM ubuntu:22.04

# Environment variable to set directory, other than the default, for Jupyter config files.
ENV JUPYTER_CONFIG_DIR "/opt/jupyterlab/config"

# Map your notebooks folder to /notebooks
RUN mkdir -p /opt/jupyterlab/notebooks
RUN mkdir -p /opt/jupyterlab/config

RUN apt update && apt install -y \
  python3 \
  python3-pip \
  python3-dev

RUN pip install jupyterlab==3.3.4

EXPOSE 8888

CMD test ! -z $PIP_PACKAGES && pip install $PIP_PACKAGES; jupyter-lab /opt/jupyterlab/notebooks --ip 0.0.0.0 --allow-root --no-browser
