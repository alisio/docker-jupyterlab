FROM ubuntu:22.04

# Environment variable to set directory, other than the default, for Jupyter config files.
ENV JUPYTER_CONFIG_DIR "/opt/jupyterlab/config"

# Map your notebooks folder to /notebooks
RUN mkdir -p /opt/jupyterlab/notebooks
RUN mkdir -p /opt/jupyterlab/config

RUN apt update && apt install -y \
      gfortran \
      libffi-dev \
      libblas3 \
      liblapack3 \
      liblapack-dev \
      libblas-dev \
      libopenblas-dev \
      libjpeg-dev \
      python3 \
      python3-pip \
      python3-dev

RUN pip install --upgrade pip && \
    pip install --upgrade setuptools wheel && \
    pip install jupyterlab==3.3.4 && \
    pip install \
      beautifulsoup4==4.11.1 \
      numpy==1.22.3 \
      pandas==1.4.2 \
      swat==1.6.1
RUN pip install matplotlib==3.5.1
RUN pip install  \
      scikit-image==0.19.2 \
      scikit-learn==1.0.2 \
      scipy==1.8.0

EXPOSE 8888

CMD test ! -z $PIP_PACKAGES && pip install $PIP_PACKAGES; jupyter-lab /opt/jupyterlab/notebooks --ip 0.0.0.0 --allow-root --no-browser
