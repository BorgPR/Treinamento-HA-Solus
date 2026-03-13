// ============================================================================
// BANCO DE DADOS DE PROJETOS - SOLUS HA
// ============================================================================
//
// 💡 COMO ADICIONAR UM NOVO CLIENTE:
// 1. Copie um bloco inteiro de cliente (de onde diz "COPIE DAQUI" até "ATÉ AQUI").
// 2. Cole logo abaixo (não esqueça da vírgula separando um cliente do outro).
// 3. Mude a palavra secreta (Token), o nome e a 'etapaAtual' (de 0 a 4).
//
// ============================================================================

const dbProjetos = {

    // --- COPIE DAQUI ---
    "UNIMED-BELEM": {
        nome: "Unimed Belém",
        
        // 🔴 INDICADOR DA FASE ATUAL: 
        // 0 = Kickoff, 1 = Provisão, 2 = Setup HA, 3 = Migração, 4 = Entregue
        etapaAtual: 1, 
        
        // DESCRIÇÕES O CLIENTE LER NO DASHBOARD:
        etapas: [
            { titulo: "Reunião de Kickoff", desc: "Alinhamento arquitetural e aprovação do projeto Solus HA.", data: "Concluído", icon: "fa-bullhorn" },
            { titulo: "Provisão de Infra", desc: "Aguardando equipe cliente liberar VMs NVMe e IPs.", data: "Sendo feito agora...", icon: "fa-server" },
            { titulo: "Setup Solus HA", desc: "Instalação do GlusterFS, Keepalived e VIP da aplicação.", data: "Aguardando infra", icon: "fa-layer-group" },
            { titulo: "Homologação", desc: "Deploy de contêineres e validação de acessos pela equipe da Unimed.", data: "Aguardando", icon: "fa-vial" },
            { titulo: "Go-Live", desc: "Mapeamento do DNS final, virada da chave em produção.", data: "Aguardando", icon: "fa-rocket" }
        ]
    },
    // --- ATÉ AQUI ---


    // --- COPIE DAQUI ---
    "SANTA-CASA": {
        nome: "Santa Casa de Misericórdia",
        etapaAtual: 3, 
        etapas: [
            { titulo: "Reunião de Kickoff", desc: "Alinhamento arquitetural e aprovação.", data: "Concluído", icon: "fa-bullhorn" },
            { titulo: "Provisão de Infra", desc: "Recursos computacionais liberados e VPN homologada.", data: "Concluído", icon: "fa-server" },
            { titulo: "Setup Solus HA", desc: "Docker Swarm e Storage Gluster instalados com sucesso.", data: "Concluído", icon: "fa-layer-group" },
            { titulo: "Homologação", desc: "Carga de banco de dados e testes de estresse.", data: "Equipe atuando...", icon: "fa-vial" },
            { titulo: "Go-Live", desc: "Entrega do ambiente produtivo com certificado SSL.", data: "Previsto: Próx semana", icon: "fa-rocket" }
        ]
    }
    // --- ATÉ AQUI ---

};
