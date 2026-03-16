#!/bin/bash

# ==============================================================================
# Script de Automação de Infraestrutura Solus HA / Single Node
# Focado em: Debian e Derivados (Ubuntu, etc.)
# ==============================================================================

# Cores para saída
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Iniciando setup da infraestrutura Solus...${NC}"

# --- 0. VERIFICAÇÕES PRÉVIAS ---

# Verifica se é root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}Erro: Por favor, execute como root ou usando sudo.${NC}"
  exit 1
fi

# Verifica se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Erro: Docker não encontrado. Instale o Docker antes de continuar.${NC}"
    exit 1
fi

# Verifica se Swarm está inicializado
SWARM_STATE=$(docker info --format '{{.Swarm.LocalNodeState}}')
if [ "$SWARM_STATE" != "active" ]; then
    echo -e "${GREEN}Inicializando Docker Swarm...${NC}"
    docker swarm init || { echo -e "${RED}Falha ao inicializar Swarm.${NC}"; exit 1; }
fi

# --- 1. USUÁRIO E GRUPO ---

echo -e "${GREEN}Configurando usuários e grupos...${NC}"

# No Debian/Ubuntu, groupadd e useradd costumam estar no base system
if ! getent group solus > /dev/null; then
    groupadd -g 1000 solus
fi

if ! getent passwd solus > /dev/null; then
    useradd -u 1000 -g 1000 -m -s /bin/bash solus
    echo -e "Defina a senha para o usuário ${GREEN}solus${NC}:"
    passwd solus
fi

# --- 2. REDE DOCKER ---

if ! docker network inspect solus-prd > /dev/null 2>&1; then
    echo -e "${GREEN}Criando rede overlay solus-prd...${NC}"
    docker network create --driver overlay --attachable solus-prd
fi

# --- 3. ESTRUTURA DE DIRETÓRIOS ---

echo -e "${GREEN}Criando estrutura de arquivos em /docker...${NC}"

criar_estrutura() {
    mkdir -p /docker/nginx/{logs,config,certs}
    mkdir -p /docker/backend/config
    mkdir -p /docker/frontend/{config,img}
    mkdir -p /docker/apache/{www,config,logs/apache}

    # Arquivos vazios base
    install -m 664 /dev/null /docker/nginx/config/default.conf
    install -m 664 /dev/null /docker/nginx/certs/certificado.crt
    install -m 600 /dev/null /docker/nginx/certs/certificado.key
    install -m 664 /dev/null /docker/nginx/nginx.yml
    install -m 664 /dev/null /docker/nginx/nginx.conf
    install -m 664 /dev/null /docker/backend/config/.env
    install -m 664 /dev/null /docker/backend/config/solus.ini
    install -m 664 /dev/null /docker/backend/api.yml
    install -m 664 /dev/null /docker/backend/wstiss.yml
    install -m 664 /dev/null /docker/frontend/config/.env
    install -m 664 /dev/null /docker/frontend/img/favicon.ico
    install -m 664 /dev/null /docker/frontend/img/logo.png
    install -m 664 /dev/null /docker/frontend/frontend.yml
    install -m 664 /dev/null /docker/apache/config/.env
    install -m 664 /dev/null /docker/apache/config/.env_web
    install -m 664 /dev/null /docker/apache/web.yml
}

# --- 4. PREENCHIMENTO DOS ARQUIVOS (YAML/CONF) ---

preencher_arquivos() {
    echo -e "${GREEN}Gerando arquivos de configuração...${NC}"

    # Nginx YML
    cat <<EOL >/docker/nginx/nginx.yml
version: "3.8"
services:
  nginx:
    image: docker.solus.inf.br/nginx:latest
    ports:
      - target: 80
        published: 80
        protocol: tcp
        mode: ingress
    volumes:
      - /docker/nginx/config:/etc/nginx/conf.d
      - /docker/nginx/logs:/var/log/nginx
      - /docker/nginx/certs:/etc/nginx/certs
      - /docker/nginx/nginx.conf:/etc/nginx/nginx.conf
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - solus-prd
networks:
  solus-prd:
    external: true
EOL

    # Nginx CONF
    cat <<EOL >/docker/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
events { worker_connections 1024; }
http {
    include /etc/nginx/mime.types;
    default_type text/html;
    server_tokens off;
    access_log /var/log/nginx/access.log;
    sendfile on;
    include /etc/nginx/conf.d/*.conf;
}
EOL

    # Web Apache YML
    cat <<EOL > /docker/apache/web.yml
version: "3.8"
services:
  web:
    image: docker.solus.inf.br/apache:7.4-19.6c
    env_file: ./config/.env
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
      - ./logs/apache:/var/log/apache2
      - ./config/.env_web:/var/www/html/.env
    deploy:
      replicas: 1
    networks:
      - solus-prd
networks:
  solus-prd:
    external: true
EOL

    # Outros arquivos podem ser preenchidos aqui seguindo o mesmo padrão...
}

# --- 5. EXECUÇÃO ---

main() {
    criar_estrutura
    preencher_arquivos

    echo -e "${GREEN}Ajustando permissões...${NC}"
    chown -R solus:solus /docker
    chmod -R 775 /docker
    chmod 600 /docker/nginx/certs/certificado.key

    echo -e "${GREEN}Realizando deploy das stacks...${NC}"
    
    cd /docker/nginx && docker stack deploy -c nginx.yml proxy
    cd /docker/apache && docker stack deploy -c web.yml solus

    echo -e "${GREEN}==================================================${NC}"
    echo -e "${GREEN}   SETUP CONCLUÍDO COM SUCESSO!${NC}"
    echo -e "${GREEN}==================================================${NC}"
}

main
