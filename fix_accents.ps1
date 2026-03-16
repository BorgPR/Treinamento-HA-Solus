$f = 'glusterfs.html'
$c = [IO.File]::ReadAllText($f, [Text.Encoding]::UTF8)
$orig = $c

$cao = [char]0xE7 + [char]0xE3 + 'o'   # ção
$ca  = [char]0xE7 + [char]0xE3          # çã

# Corrige palavras onde "ção" foi truncado para apenas "c" ou removido
$fixes = @(
    @('Documentac:', 'Documentação:'),
    @('Documentac<',  'Documentação<'),
    @('Replicac<',   'Replicação<'),
    @('Monitor de Replicac<', 'Monitor de Replicação<'),
    @('replicac tripla', 'replicação tripla'),
    @('replicac de dados', 'replicação de dados'),
    @('operac.', 'operação.'),
    @('Implementac Passo', 'Implementação Passo'),
    @('Roteiro de Implementac', 'Roteiro de Implementação'),
    @('Preparac da Infraestrutura', 'Preparação da Infraestrutura'),
    @('Fase 1: Preparac', 'Fase 1: Preparação'),
    @('Formac do Cluster', 'Formação do Cluster'),
    @('1. Formac ', 'Formação '),
    @('Criac do Volume', 'Criação do Volume'),
    @('2. Criac ', '2. Criação '),
    @('Orquestrac (Docker', 'Orquestração (Docker'),
    @('Fase 3: Orquestrac', 'Fase 3: Orquestração'),
    @('Configurac do', 'Configuração do'),
    @('Configurac recomendadas', 'Configuração recomendadas'),
    @('Validac de Alta', 'Validação de Alta'),
    @('Fase 6: Validac', 'Fase 6: Validação'),
    @('Partic Raiz', 'Partição Raiz'),
    @('Auto-Reaparac)', 'Auto-Reparação)'),
    @('Reaparac)', 'Reparação)'),
    @('Healing (Auto-Reaparac', 'Healing (Auto-Reparação')
)

foreach ($pair in $fixes) {
    $c = $c.Replace($pair[0], $pair[1])
}

if ($c -ne $orig) {
    [IO.File]::WriteAllText($f, $c, [Text.Encoding]::UTF8)
    Write-Host "Corrigido: $f"
} else {
    Write-Host "Sem alteracoes"
}
