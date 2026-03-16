// ====================================
// GERADO AUTOMATICAMENTE VIA PAINEL TIP
// ====================================

const dbProjetos = {
    "UNIMED-BELEM": {
        nome: "Unimed Belém",
        etapaAtual: 1,
        etapas: [
            { titulo: "Reunião de Kickoff", desc: "Alinhamento arquitetural e aprovação do projeto Solus HA.", data: "Concluído", icon: "fa-bullhorn" },
            { titulo: "Provisão de Infra", desc: "Aguardando equipe cliente liberar VMs NVMe e IPs.", data: "Sendo feito agora...", icon: "fa-server" },
            { titulo: "Setup Solus HA", desc: "Instalação do GlusterFS, Keepalived e VIP da aplicação.", data: "Aguardando infra", icon: "fa-layer-group" },
            { titulo: "Homologação", desc: "Deploy de contêineres e validação de acessos pela equipe da Unimed.", data: "Aguardando", icon: "fa-vial" },
            { titulo: "Go-Live", desc: "Mapeamento do DNS final, virada da chave em produção.", data: "Aguardando", icon: "fa-rocket" }
        ]
    },
    "SANTA-CASA": {
        nome: "Santa Casa de Misericórdia",
        etapaAtual: 3,
        etapas: [
            { titulo: "Reunião de Kickoff", desc: "Alinhamento arquitetural e aprovação do projeto Solus HA.", data: "Concluído", icon: "fa-bullhorn" },
            { titulo: "Provisão de Infra", desc: "Aguardando equipe cliente liberar VMs NVMe e IPs.", data: "Concluído", icon: "fa-server" },
            { titulo: "Setup Solus HA", desc: "Instalação do GlusterFS, Keepalived e VIP da aplicação.", data: "Concluído", icon: "fa-layer-group" },
            { titulo: "Homologação", desc: "Deploy de contêineres e validação de acessos pela equipe da Unimed.", data: "Equipe atuando...", icon: "fa-vial" },
            { titulo: "Go-Live", desc: "Mapeamento do DNS final, virada da chave em produção.", data: "Previsto: Próx semana", icon: "fa-rocket" }
        ]
    },
    "CABEFI": {
        nome: "cabefi",
        etapaAtual: 1,
        etapas: [
            { titulo: "Reunião de Kickoff", desc: "Alinhamento arquitetural e aprovação do projeto Solus HA.", data: "Concluído", icon: "fa-bullhorn" },
            { titulo: "Provisão de Infra", desc: "Aguardando equipe cliente liberar VMs NVMe e IPs.", data: "Em andamento...", icon: "fa-server" },
            { titulo: "Setup Solus HA", desc: "Instalação do GlusterFS, Keepalived e VIP da aplicação.", data: "Aguardando...", icon: "fa-layer-group" },
            { titulo: "Homologação", desc: "Deploy de contêineres e validação de acessos pela equipe da Unimed.", data: "Aguardando...", icon: "fa-vial" },
            { titulo: "Go-Live", desc: "Mapeamento do DNS final, virada da chave em produção.", data: "Aguardando...", icon: "fa-rocket" }
        ]
    },
    "FACIL-SAAS": {
        nome: "Fácil-SaaS (Projeto Espetaria)",
        etapaAtual: 1,
        etapas: [
            { 
                titulo: "Fase 1: Levantamento e Preparação", 
                desc: "Inventário da aplicação (PHP, extensões, Apache), instalação do Docker nos hosts Linux e inicialização do Swarm Cluster.", 
                data: "Concluído", 
                icon: "fa-list-check" 
            },
            { 
                titulo: "Fase 2: Containerização", 
                desc: "Criação de Dockerfiles (Web/DB) e estruturação do arquivo docker-compose.yml para orquestração no Swarm.", 
                data: "Em execução...", 
                icon: "fa-box" 
            },
            { 
                titulo: "Fase 3: Homologação e Dados", 
                desc: "Migração de Banco de Dados (Dump/Restore), ajuste de caminhos de arquivos (Linux paths) e deploy da Stack para teste.", 
                data: "Aguardando", 
                icon: "fa-vial" 
            },
            { 
                titulo: "Fase 4: Cutover e Go-Live", 
                desc: "Janela de manutenção, sincronização final dos volumes e apontamento de DNS para a produção no Swarm.", 
                data: "Aguardando", 
                icon: "fa-rocket" 
            }
        ],
        observacoes: [
            { item: "Case Sensitivity", xampp: "Insensível (arquivo.php = Arquivo.php)", docker: "Sensível (Devem ser idênticos)" },
            { item: "Rede", xampp: "Localhost / Portas Estáticas", docker: "Ingress Network / Overlay Network" },
            { item: "Logs", xampp: "C:\\xampp\\apache\\logs", docker: "docker service logs -f" },
            { item: "Persistência", xampp: "Pasta local no Disco", docker: "Volumes Gerenciados ou Bind Mounts" }
        ]
    }
};
