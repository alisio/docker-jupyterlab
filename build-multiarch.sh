#!/bin/bash

# Script para build e publicação multi-arquitetura no Docker Hub
# Suporta: AMD64 (Intel/AMD), ARM64 (Apple Silicon), ARM64 (Raspberry Pi)

set -e

# Configurações
DOCKER_USERNAME="alisio"
IMAGE_NAME="jupyter-lab"
VERSION="latest"
PLATFORMS="linux/amd64,linux/arm64"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Função para verificar pré-requisitos
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker not found. Please install Docker Desktop."
        exit 1
    fi
    
    # Verificar login no Docker Hub
    if ! docker info | grep -q "Username: $DOCKER_USERNAME"; then
        print_warning "Not logged in to Docker Hub. Please run: docker login"
        exit 1
    fi
    
    # Verificar buildx
    if ! docker buildx version &> /dev/null; then
        print_error "Docker buildx not available. Please update Docker Desktop."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Função para configurar buildx
setup_buildx() {
    print_status "Setting up Docker buildx..."
    
    # Criar builder se não existir
    if ! docker buildx ls | grep -q "multiarch"; then
        print_status "Creating multiarch builder..."
        docker buildx create --name multiarch --driver docker-container --use
        docker buildx inspect --bootstrap
    else
        print_status "Using existing multiarch builder..."
        docker buildx use multiarch
    fi
    
    print_success "Buildx setup completed"
}

# Função para build e push
build_and_push() {
    local tag="$DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
    
    print_status "Building and pushing multi-architecture image..."
    print_status "Platforms: $PLATFORMS"
    print_status "Tag: $tag"
    
    # Build e push para múltiplas arquiteturas
    docker buildx build \
        --platform $PLATFORMS \
        --tag $tag \
        --push \
        .
    
    if [ $? -eq 0 ]; then
        print_success "Multi-architecture build and push completed!"
        print_success "Image available at: https://hub.docker.com/r/$DOCKER_USERNAME/$IMAGE_NAME"
    else
        print_error "Build failed!"
        exit 1
    fi
}

# Função para testar as imagens
test_images() {
    local tag="$DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
    
    print_status "Testing images for different architectures..."
    
    # Testar AMD64
    print_status "Testing AMD64 image..."
    docker run --rm --platform linux/amd64 $tag python --version
    
    # Testar ARM64 (se disponível)
    if [[ $(uname -m) == "arm64" ]]; then
        print_status "Testing ARM64 image..."
        docker run --rm --platform linux/arm64 $tag python --version
    fi
    
    print_success "Image tests completed"
}

# Função para mostrar informações da imagem
show_image_info() {
    local tag="$DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
    
    print_status "Image information:"
    docker buildx imagetools inspect $tag
}

# Função principal
main() {
    local action=${1:-"all"}
    
    case $action in
        "build")
            check_prerequisites
            setup_buildx
            build_and_push
            ;;
        "test")
            test_images
            ;;
        "info")
            show_image_info
            ;;
        "all")
            check_prerequisites
            setup_buildx
            build_and_push
            test_images
            show_image_info
            ;;
        *)
            echo "Usage: $0 [build|test|info|all]"
            echo ""
            echo "Commands:"
            echo "  build - Build and push multi-architecture image"
            echo "  test  - Test images for different architectures"
            echo "  info  - Show image information"
            echo "  all   - Run all commands (default)"
            echo ""
            echo "Supported platforms:"
            echo "  - linux/amd64 (Intel/AMD PCs)"
            echo "  - linux/arm64 (Apple Silicon, Raspberry Pi 64-bit)"
            echo ""
            echo "Before running, make sure you're logged in:"
            echo "  docker login"
            exit 1
            ;;
    esac
}

# Executar função principal
main "$@"
