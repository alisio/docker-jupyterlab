# Docker Jupyter Lab

Build a docker image for a container capable of running jupyter notebooks using Jupyter Lab.
The image is flexible enough so you can install additional python packages as
needed using special environment variables.

# Build

Build the image running the command inside the repo folder:
```
docker build -t alisio/jupyter-lab .
```

# Usage

## Basic

Basic usage with default python packages:

```sh
docker run \
  --name alisio-jupyter-lab \
  -p 8888:8888 \
  -v <path to notebooks>:/opt/jupyterlab/notebooks \
  -v <path to config>:/opt/jupyterlab/config \
  alisio/jupyter-lab
```

## Installing additional packages

It is possible to install additional python packages setting the PIP_PACKAGES environment
variable. The format is simple and consists of a string of package names separated by
a space (e.g: "numpy pandas requests"):

```sh
docker run \
  --name alisio-jupyter-lab \
  -p 8888:8888 \
  -v <path to notebooks>:/opt/jupyterlab/notebooks \
  -v <path to config>:/opt/jupyterlab/config \
  -e PIP_PACKAGES="package1 package2 ..." \
  alisio/jupyter-lab
```

Mind you that installing additional packages can break the container.

# Authorization Token

Get the authorization token running the following command on your terminal:

```sh
docker exec alisio-jupyter-lab jupyter server list
```

It should return the authorization token among other information:

```
Currently running servers:
http://effae095fdb9:8888/?token=9e5ad61ebce3d2b9050b5a1eege0a6eca4cf118c05ee7def :: /opt/jupyterlab/notebooks
```

# Author

Antonio Alisio de Meneses Cordeiro - alisio.meneses@gmail.com
