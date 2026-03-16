#!/bin/bash

# Este script unifica a configuração completa da aplicação "solus"
# em um único processo, criando usuários, estrutura de diretórios,
# arquivos de configuração e redes Docker para Nginx, Backend e Frontend.

# --- 1. VERIFICAÇÃO E CRIAÇÃO DO USUÁRIO E GRUPO SOLUS ---

# Instala o pacote 'shadow' se necessário para gerenciar usuários e grupos
if ! command -v groupadd &> /dev/null; then
    echo "Instalando o pacote 'shadow' para gerenciar usuários e grupos..."
    apk add shadow
fi

# Cria o grupo "solus" se ele não existir
if ! getent group solus > /dev/null; then
    echo "O grupo 'solus' não existe. Criando..."
    groupadd -g 1000 solus
fi

# Cria o usuário "solus" se ele não existir e solicita a definição de senha
if ! getent passwd solus > /dev/null; then
    echo "O usuário 'solus' não existe. Criando..."
    useradd -u 1000 -g 1000 -m -s /bin/bash solus
    echo "Por favor, defina uma senha para o usuário 'solus'."
    passwd solus
fi

# --- 2. CRIAÇÃO DA REDE DOCKER ---

# Verifica se a rede Docker 'solus-prd' já existe antes de criá-la
if ! docker network inspect solus-prd > /dev/null 2>&1; then
    echo "Criando a rede Docker 'solus-prd'..."
    docker network create --driver overlay --attachable solus-prd
else
    echo "A rede Docker 'solus-prd' já existe."
fi

# --- 3. FUNÇÕES PARA CRIAÇÃO E PREENCHIMENTO DOS ARQUIVOS ---

# Função para criar a estrutura completa de diretórios e arquivos
criar_estrutura() {
    echo "Criando a estrutura de diretórios completa..."
    mkdir -p /docker/nginx/{logs,config,certs}
    mkdir -p /docker/backend/config
    mkdir -p /docker/frontend/{config,img}
    mkdir -p /docker/apache/{www,config,logs/apache}

    echo "Criando arquivos vazios com permissões iniciais..."
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

# Preenche o arquivo nginx.yml
preencher_nginx_yml() {
    echo "Preenchendo o arquivo nginx.yml..."
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
      - type: bind
        source: /docker/nginx/config
        target: /etc/nginx/conf.d
      - type: bind
        source: /docker/nginx/logs
        target: /var/log/nginx
      - type: bind
        source: /docker/nginx/certs
        target: /etc/nginx/certs
      - type: bind
        source: /docker/nginx/nginx.conf
        target: /etc/nginx/nginx.conf
    
    deploy:
      mode: replicated
      replicas: 1
    networks:
      - solus-prd

networks:
  solus-prd:
    external: true
EOL
}

# Preenche o arquivo nginx.conf
preencher_nginx_conf() {
    echo "Preenchendo o arquivo nginx.conf..."
    cat <<EOL >/docker/nginx/nginx.conf
user nginx;
worker_processes 1;

error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type text/html;
    tcp_nodelay on;

    client_max_body_size 0;

    server_tokens off;

    limit_conn_zone \$binary_remote_addr zone=addr:100m;
    limit_conn addr 1000;
    limit_conn_zone \$binary_remote_addr zone=perip:100m;
    limit_conn_zone \$server_name zone=perserver:100m;
    limit_req_zone \$binary_remote_addr zone=one:100m rate=1r/s;

    log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                     '\$status \$body_bytes_sent "\$http_referer" '
                     '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    keepalive_timeout 65;

    include /etc/nginx/conf.d/*.conf;
}
EOL
}

# Preenche o arquivo default.conf
preencher_default_conf() {
    echo "Preenchendo o arquivo default.conf..."
    cat <<EOL >/docker/nginx/config/default.conf
# Redirecionamento para o ambiente seguro caso haja tentativa de acesso via HTTP, porta 80
#server {
#    listen 80 default_server;
#    server_name prestador.operadora.com.br;
#    return 301 https://\$host\$request_uri;
#}

server {
    listen 80 ;
    server_name prestador.operadora.com.br;

    #ssl_certificate /etc/nginx/certs/certificado.crt;
    #ssl_certificate_key /etc/nginx/certs/certificado.key;

#    location / {
#        proxy_pass http://solus_web;
#    }

#         location /tiss/ {
#         rewrite /tiss/(.*) /TISSSolus40100/\$1 break; #identifique o nome do projeto verificando o log do containe
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-Host \$host;
#         proxy_set_header X-Forwarded-Server \$host;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_pass  http://ws_tiss401 ; #verifique se existe upstream se nao exisitir informe ip e porta do servico
#         proxy_redirect off;
#         proxy_set_header Accept-Encoding "";
#         sub_filter_once off;
#         sub_filter_types *;
#         sub_filter 'http://\$host:80/tissSolus40100' 'https://tiss.unimed531.coop.br/tiss'; #estes filtros dependem do nome do projeto
#         sub_filter 'http://\$host:80/tissSolus40100' 'https://\$host/tiss'; #estes filtros dependem do nome do projeto
#         }

}
EOL
}

# Preenche o arquivo web.yml
preencher_web_yml() {
    echo "Preenchendo o arquivo web.yml..."
    cat <<EOL > /docker/apache/web.yml
version: "3.8"

services:
  web:
    deploy:
      replicas: 1
      restart_policy:
        condition: any
    image: docker.solus.inf.br/apache:7.4-19.6c
    env_file:
      - ./config/.env
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
      - ./logs/apache:/var/log/apache2
      - ./config/.env_web:/var/www/html/.env
    networks:
      - solus-prd

networks:
  solus-prd:
    external: true
EOL
}

# Preenche o arquivo wstiss.yml
preencher_wstiss_yml() {
    echo "Preenchendo o arquivo wstiss.yml..."
    cat <<EOL > /docker/backend/wstiss.yml
version: "3.8"

services:
  ws_tiss:
    image: docker.solus.inf.br/ws_tiss:2025.02
    ports:
      - "8181:8080"
    deploy:
      replicas: 1
      restart_policy:
        condition: any
    volumes:
      - /docker/backend/config/solus.ini:/opt/solus/solus.ini
    networks:
      - solus-prd

networks:
  solus-prd:
    external: true
EOL
}

# Preenche o novo arquivo api.yml
preencher_api_yml() {
    echo "Preenchendo o arquivo api.yml..."
    cat <<EOL > /docker/backend/api.yml
version: '3.8'

services:

  api_beneficiario:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-1
    image: docker.solus.inf.br/api_beneficiario:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15010
        published: 15010
        protocol: tcp
    networks:
      - solus-prd

  api_contrato:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-2
    image: docker.solus.inf.br/api_contrato:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15140
        published: 15140
        protocol: tcp
    networks:
      - solus-prd

  api_guia:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-1
    image: docker.solus.inf.br/api_guia:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15040
        published: 15040
        protocol: tcp
    networks:
      - solus-prd

  api_webbeneficiario:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-3
    image: docker.solus.inf.br/api_webbeneficiario:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    networks:
      - solus-prd

  api_solus:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-4
    image: docker.solus.inf.br/api_solus:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15100
        published: 15100
        protocol: tcp
    networks:
      - solus-prd

  api_login:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-1
    image: docker.solus.inf.br/api_login:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15160
        published: 15160
        protocol: tcp
    networks:
      - solus-prd

  api_financeiro:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-2
    image: docker.solus.inf.br/api_financeiro:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15090
        published: 15090
        protocol: tcp
    networks:
      - solus-prd

  api_estoque:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-3
    image: docker.solus.inf.br/api_estoque:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 16080
        published: 16080
        protocol: tcp
    networks:
      - solus-prd

  api_auditoria:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-4
    image: docker.solus.inf.br/api_auditoria:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 16090
        published: 16090
        protocol: tcp
    networks:
      - solus-prd

  api_integracao:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-1
    image: docker.solus.inf.br/api_integracao:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15170
        published: 15170
        protocol: tcp
    networks:
      - solus-prd

  api_contas:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-2
    image: docker.solus.inf.br/api_contas:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15030
        published: 15030
        protocol: tcp
    networks:
      - solus-prd

  api_prestador:
    deploy:
      replicas: 1
      # placement:
      #   constraints:
      #     - node.hostname == nome-do-seu-no-3
    image: docker.solus.inf.br/api_prestador:2025.02
    env_file:
      - ./config/.env
    volumes:
      - ./config/solus.ini:/home/solus/api/solus.ini
    ports:
      - target: 15050
        published: 15050
        protocol: tcp
    networks:
      - solus-prd

networks:
  solus-prd:
    external: true
EOL
}

# Preenche o arquivo frontend.yml (com base no original fornecido)
preencher_frontend_yml() {
    echo "Preenchendo o arquivo frontend.yml..."
    cat <<EOL > /docker/frontend/frontend.yml
version: "3.8"

services:
  frontend:
    image: docker.solus.inf.br/frontend:latest
    ports:
      - "8000:80"
    deploy:
      replicas: 1
      restart_policy:
        condition: any
    networks:
      - solus-prd

networks:
  solus-prd:
    external: true
EOL
}

# --- 4. FUNÇÃO PRINCIPAL QUE EXECUTA TUDO ---

main() {
    # 1. Cria a estrutura de diretórios e arquivos
    criar_estrutura

    # 2. Preenche os arquivos de configuração
    preencher_nginx_yml
    preencher_nginx_conf
    preencher_default_conf
    preencher_web_yml
    preencher_wstiss_yml
    preencher_api_yml
    preencher_frontend_yml

    # 3. Aplica as permissões e propriedade
    echo "Alterando a propriedade de /docker para solus:solus..."
    chown -R solus:solus /docker

    echo "Aplicando permissões de diretórios (775)..."
    find /docker -type d -print0 | xargs -0 chmod 775

    echo "Aplicando permissões de arquivos (664)..."
    find /docker -type f -print0 | xargs -0 chmod 664
    
    # Restringe a permissão da chave privada
    echo "Ajustando permissão da chave privada para 600..."
    chmod 600 /docker/nginx/certs/certificado.key

    # 4. Implanta os serviços Docker usando os nomes de stack originais
    echo "Implantando o stack 'proxy' (Nginx)..."
    cd /docker/nginx || { echo "Falha ao entrar no diretório /docker/nginx. Abortando."; exit 1; }
    docker stack deploy -c nginx.yml proxy

    echo "Implantando o stack 'solus' (Apache e Backend - wstiss)..."
    cd /docker/apache || { echo "Falha ao entrar no diretório /docker/apache. Abortando."; exit 1; }
    docker stack deploy -c web.yml solus

    # Implanta a nova stack 'backend'
    echo "Implantando o stack 'backend' (APIs)..."
    cd /docker/backend || { echo "Falha ao entrar no diretório /docker/backend. Abortando."; exit 1; }
    docker stack deploy -c wstiss.yml solus
    docker stack deploy -c api.yml backend

    echo "---"
    echo "Estrutura, permissões e serviços Docker configurados com sucesso."
}

# Executa a função principal
main
