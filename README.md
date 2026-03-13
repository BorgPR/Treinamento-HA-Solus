# Portal de Engenharia de Infraestrutura HA — Solus Saúde

Projeto de documentação interativa, simulações visuais e avaliação de conhecimento sobre a arquitetura de **Alta Disponibilidade (HA)** da Solus Saúde.

## 🚀 Mapeamento dos Módulos

* **`index.html`** - Portal Principal do projeto. Exibição unificada para todos os links públicos.
* **`visaogeral.html`** - Simulação do Cluster Docker Swarm com Nginx (Edge), Failover Automático com Keepalived e banco Oracle isolado.
* **`glusterfs.html`** - Arquitetura de Storage Distribuído (GlusterFS) rodando no modelo réplica 3x com Self-Heal. 
* **`Treinamento_Final_HA.html`** - Trilha completa de conhecimento e questionário interativo para certificações internas.

## 🛠️ Padrão de Versionamento (Git)

As atualizações no código deste repositório devem seguir os **Conventional Commits** para clareza sobre o tipo de alteração no histórico:
* **`feat:`** Nova funcionalidade (ex: Adição de novo card/simulação)
* **`fix:`** Correção em um comportamento existente (ex: Ajuste no alinhamento Mobile)
* **`docs:`** Alteração exclusiva em textos documentais, guias ou manuais
* **`build:`** Marcações de grandes lançamentos / empacotamentos
* **`style:`** Formatação, quebra de linha (sem afetar lógica)

### Tags Oficiais
* A versão limpa consolidada com todo o portal padronizado, tema persistente e modo HA interativo nasce a partir da **v2.0**.
