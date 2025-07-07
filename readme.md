# Docker JupyterLab

Build and deploy a container capable of running Jupyter notebooks using JupyterLab.
The Dockerfile creates a minimal and secure image based on `python:3.12-slim` that runs as a non-root user, with the flexibility to install additional Python packages at runtime using environment variables.

You can build your own image or pull it from the docker hub [`alisio/jupyter-lab`](https://hub.docker.com/r/alisio/jupyter-lab)

## Features

* **Based on Python 3.12 Slim** - Official Python image for optimal performance
* **Runs as non-root user** for enhanced security  
* **Minimal base image** (331MB) with only essential dependencies
* **Runtime package installation** support via environment variables
* **Health check** for container monitoring
* **Tini init system** for proper signal handling
* **No authentication** by default for development

## Preinstalled Python Libraries

The following python packages are installed during the build:

* `jupyterlab` (latest version)

This minimal setup allows you to install additional packages as needed, either by modifying the `requirements.txt` file or using the `PIP_PACKAGES` environment variable at runtime.

## System Requirements

* Docker Engine 20.10+ or Docker Desktop
* At least 1GB of available RAM
* At least 2GB of free disk space

# Build

## Single Architecture Build

Build the image running the command inside the repo folder:
```bash
docker build -t alisio/jupyter-lab .
```

## Multi-Architecture Build (Apple Silicon + Raspberry Pi + Intel/AMD)

To build and publish images for multiple architectures (Intel/AMD, Apple Silicon, Raspberry Pi 64-bit):

### Prerequisites
1. **Docker Desktop** with buildx enabled
2. **Docker Hub account** and login: `docker login`

### Build and Publish
```bash
# Build and push to Docker Hub for all architectures
./build-multiarch.sh

# Or step by step:
./build-multiarch.sh build    # Build and push
./build-multiarch.sh test     # Test images
./build-multiarch.sh info     # Show image info
```

### Supported Platforms
- `linux/amd64` - Intel/AMD PCs and servers
- `linux/arm64` - Apple Silicon Macs (M1/M2/M3)
- `linux/arm64` - Raspberry Pi 4/5 (64-bit OS)

The multi-architecture images are automatically available at:
`docker pull alisio/jupyter-lab:latest`

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
  -e PIP_PACKAGES="numpy pandas matplotlib scikit-learn" \
  alisio/jupyter-lab
```

### Example with local directories:

```sh
docker run \
  --namxe alisio-jupyter-lab \
  -p 8888:8888 \
  -v $(pwd)/notebooks:/opt/jupyterlab/notebooks \
  -v $(pwd)/config:/opt/jupyterlab/config \
  -e PIP_PACKAGES="numpy pandas matplotlib plotly seaborn" \
  alisio/jupyter-lab
```

Mind you that installing additional packages can break the container.

## Using Docker Compose (Recommended)

For easier management, use the included `docker-compose.yml`:

```sh
# Start JupyterLab
docker-compose up -d

# Stop JupyterLab
docker-compose down

# View logs
docker-compose logs -f
```

Access JupyterLab at: http://localhost:8888

## Container Management

### Stop the container:
```sh
docker stop alisio-jupyter-lab
```

### Remove the container:
```sh
docker rm alisio-jupyter-lab
```

### View container logs:
```sh
docker logs alisio-jupyter-lab
```

# Author

Antonio Alisio de Meneses Cordeiro - alisio.meneses@gmail.com
