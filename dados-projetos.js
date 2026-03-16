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
    }
};
