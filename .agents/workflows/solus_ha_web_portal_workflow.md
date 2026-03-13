---
description: Workflow padrão para manutenção, padronização e publicação do Portal Web Solus HA
---

# Workflow: Portal de Infraestrutura Solus HA

Este workflow documenta o processo padrão adotado para a organização, estilização e publicação do projeto web estático de documentação de Alta Disponibilidade (HA) da Solus. Outros agentes devem seguir estas diretrizes ao realizar a manutenção deste projeto.

## 1. Padronização de Design e Interface (UI/UX)
- **Glassmorphism e Layout:** Todo novo card ou componente deve utilizar a classe `.glass` com fundo semitransparente, `backdrop-filter: blur`, e seguir as variáveis de paleta de cores CSS (`--primary`, `--secondary`, etc.).
- **Responsividade e Flexbox:** Ao utilizar `display: flex` em cards com texto que não deve quebrar linha (`white-space: nowrap`), é obrigatório adicionar `<div style="min-width: 0; overflow: hidden; text-overflow: ellipsis;">` no container de texto para evitar vazamento (overflow) da div pai.
- **Dark/Light Mode:** A persistência de tema utiliza o `localStorage` na chave `solus-theme`. Qualquer nova página HTML deve importar/conter o script de inicialização e o EventListener no botão `#theme-toggle`.
- **Dimensões:** As áreas de documento principal sempre utilizam `.doc-content` com `max-width: 900px` para consistência visual.

## 2. Estrutura de Arquivos e Dados
- **Portal Principal (`index.html`):** Atua como o hub/ponto de entrada para os sub-módulos. Qualquer novo módulo adicionado ao projeto deve receber um novo `<a class="module-card">` no index.
- **Desacoplamento de Dados:** Dados dinâmicos para o cliente final (como a linha do tempo em `projetos.html`) não devem estar misturados com o HTML. É mandatório separá-los em arquivos JavaScript dedicados (como `dados-projetos.js`), configurando objetos simples (JSON) com instruções fáceis para edição humana via Notepad.
- **Limpeza:** Arquivos temporários (.tmp, scripts isolados de teste, mockups antigos) devem ser deletados. Apenas os arquivos HTML vitais de produção e PDFs oficiais devem permanecer na raiz.

## 3. Controle de Versão (Git)
A pasta do projeto é um repositório Git. As alterações devem ser "commitadas" seguindo rigorosamente os *Conventional Commits*:
- `feat:` Novas páginas, simulações ou recursos visuais.
- `fix:` Correções de bugs de CSS, links quebrados ou scripts.
- `docs:` Alterações de texto na documentação HTML, cronograma ou inclusão de novos guias.
- `style:` Formatações sem impacto lógico.

## 4. Publicação na Intranet (Deploy)
A Solus hospeda a página via rede local em `\\172.16.80.15\WebTemp\infra\`.
Sempre que uma modificação for finalizada no código e o commit feito:
1. Adicione o nome de quaisquer páginas novas ou arquivos `.js` que precisem subir ao script `publicar.bat`.
2. Rode o script automatizado de deploy `publicar.bat` (batch windows). Ele usa `copy /Y` para enviar tudo silenciosamente ao servidor local. **Não é recomendada a publicação manual copiando arquivo por arquivo.**

// turbo
## 5. Passos para Adição de Novo Recurso
1. Crie/edite o HTML seguindo o CSS global.
2. Certifique-se que `.doc-content` e DarkMode estejam operacionais.
3. Se gerar novo HTML, integre-o ao `index.html` e ao `publicar.bat`.
4. Faça o `git add .` e o `git commit -m "feat: sua nova feature"`.
5. Execute `publicar.bat` e em seguida `git push origin main`.
