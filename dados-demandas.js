// ============================================================================
// SUAS DEMANDAS E TAREFAS DA OPERAÇÃO (TIP)
// ============================================================================
//
// 💡 COMO ADICIONAR UMA NOVA TAREFA:
// 1. Copie uma linha inteira (dentro das chaves { }).
// 2. Cole na linha de baixo e não esqueça da vírgula.
// 3. Status válidos: "pendente", "execucao", "homologacao", "concluido".
// 4. Prioridades sugeridas: "Alta", "Média", "Baixa", "Urgente".
// ============================================================================

const minhasDemandas = [
    { 
        id: "T-001", 
        titulo: "Provisão de Cluster Unimed", 
        cliente: "Unimed Belém", 
        status: "execucao", 
        prioridade: "Alta", 
        prazo: "15/03/2026", 
        tags: "Docker, GlusterFS" 
    },
    { 
        id: "T-002", 
        titulo: "Troubleshooting de Rede IPSec", 
        cliente: "Santa Casa", 
        status: "pendente", 
        prioridade: "Urgente", 
        prazo: "Hoje", 
        tags: "Redes, Firewall" 
    },
    { 
        id: "T-003", 
        titulo: "Atualização Certificado SSL Proxy", 
        cliente: "Infra Solus", 
        status: "pendente", 
        prioridade: "Média", 
        prazo: "20/03/2026", 
        tags: "Segurança" 
    },
    { 
        id: "T-004", 
        titulo: "Homologação Ambiente Oracle HA", 
        cliente: "Hospital Modelo", 
        status: "homologacao", 
        prioridade: "Alta", 
        prazo: "16/03/2026", 
        tags: "DBA, Oracle" 
    },
    { 
        id: "T-005", 
        titulo: "Documentação da Arquitetura v2", 
        cliente: "Infra Solus", 
        status: "concluido", 
        prioridade: "Baixa", 
        prazo: "13/03/2026", 
        tags: "Docs" 
    }
];
