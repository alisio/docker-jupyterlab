# Docker Jupyter Lab

Build and deploy a container running jupyter notebooks using Jupyter Lab.
The Dockerfile creates an image that is flexible enough so you can install additional python
packages at run-time as needed using special environment variables.

You can build your own image or pull it from the docker hub [`alisio/jupyter-lab`](https://hub.docker.com/r/alisio/jupyter-lab)

There are images available for the following architectures:

* linux/amd64
* linux/arm64
* linux/arm/v7

# Preinstalled Python libs

The following python packages are installer during the build:

* `jupyterlab` 3.3.4
* `beautifulsoup4` 4.11.1
* `matplotlib` 3.5.1
* `numpy` 1.22.3
* `pandas` 1.4.2
* `scikit` mage 0.19.2
* `scikit` earn 1.0.2
* `scipy` 1.8.0
* `swat` 1.6.1


# Build

Build the image running the command inside the repo folder:
```
docker build -t alisio/jupyter-lab .
```

# Run

## Basic container

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
