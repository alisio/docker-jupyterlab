# Guia: Build Multi-Arquitetura e Publicação no Docker Hub

Este guia mostra como construir e publicar imagens Docker para múltiplas arquiteturas.

## Arquiteturas Suportadas

| Plataforma | Descrição | Uso |
|------------|-----------|-----|
| `linux/amd64` | Intel/AMD 64-bit | PCs, Servidores, Cloud |
| `linux/arm64` | ARM 64-bit | Apple Silicon (M1/M2/M3), Raspberry Pi 4/5 |

## Método 1: Script Automatizado (Recomendado)

### Pré-requisitos
```bash
# 1. Instalar Docker Desktop
# 2. Fazer login no Docker Hub
docker login

# 3. Verificar buildx
docker buildx version
```

### Build e Publicação
```bash
# Build e publicar para todas as arquiteturas
./build-multiarch.sh

# Ou comandos específicos:
./build-multiarch.sh build    # Build e push
./build-multiarch.sh test     # Testar imagens
./build-multiarch.sh info     # Ver informações
```

## Método 2: Comandos Manuais

### 1. Configurar Buildx
```bash
# Criar builder multi-arquitetura
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap
```

### 2. Build Multi-Arquitetura
```bash
# Build e push
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag alisio/jupyter-lab:latest \
  --push \
  .
```

### 3. Verificar Resultado
```bash
# Ver informações da imagem
docker buildx imagetools inspect alisio/jupyter-lab:latest

# Testar AMD64
docker run --rm --platform linux/amd64 alisio/jupyter-lab:latest python --version

# Testar ARM64
docker run --rm --platform linux/arm64 alisio/jupyter-lab:latest python --version
```

## Método 3: Automação GitHub Actions

O repositório inclui GitHub Actions para build automático:

### Configuração no GitHub
1. **Adicionar Secrets** no repositório:
   - `DOCKER_USERNAME` - Seu usuário Docker Hub
   - `DOCKER_PASSWORD` - Seu token/senha Docker Hub

2. **Push para main/master** - Trigger automático do build

3. **Tags de versão** - Cria releases com versionamento:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

## Uso por Usuários Finais

### Pull Automático da Arquitetura Correta
```bash
# Docker automaticamente puxa a arquitetura correta
docker pull alisio/jupyter-lab:latest

# Especificar arquitetura (opcional)
docker pull --platform linux/amd64 alisio/jupyter-lab:latest
docker pull --platform linux/arm64 alisio/jupyter-lab:latest
```

### Verificar Arquitetura
```bash
# Ver arquitetura da imagem local
docker image inspect alisio/jupyter-lab:latest | grep Architecture

# Ver todas as arquiteturas disponíveis
docker buildx imagetools inspect alisio/jupyter-lab:latest
```

## Testando no Apple Silicon (M1/M2/M3)

```bash
# Verificar arquitetura do sistema
uname -m
# Resultado: arm64

# Pull e run (automaticamente usa ARM64)
docker run -p 8888:8888 alisio/jupyter-lab:latest

# Forçar AMD64 (emulação, mais lento)
docker run --platform linux/amd64 -p 8888:8888 alisio/jupyter-lab:latest
```

## Testando no Raspberry Pi 4/5 (64-bit)

```bash
# Instalar Docker (se não instalado)
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Pull e run (automaticamente usa ARM64)
docker run -p 8888:8888 alisio/jupyter-lab:latest
```

## Troubleshooting

### Erro: "buildx not found"
```bash
# Atualizar Docker Desktop para versão mais recente
# Ou instalar buildx plugin
```

### Erro: "no space left on device"
```bash
# Limpar cache do Docker
docker system prune -a
docker buildx prune
```

### Erro: "platform not supported"
```bash
# Verificar plataformas disponíveis
docker buildx ls

# Reinstalar buildx
docker buildx rm multiarch
docker buildx create --name multiarch --driver docker-container --use
```

## Verificação Final

Após publicação, verificar:
1. **Docker Hub** - Múltiplas arquiteturas visíveis
2. **Pull test** - Funciona em diferentes sistemas
3. **Performance** - ARM64 nativo vs emulação AMD64

A imagem estará disponível em: https://hub.docker.com/r/alisio/jupyter-lab
