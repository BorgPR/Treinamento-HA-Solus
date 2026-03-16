const fs = require('fs');

const csvData = `Token         ; Nome                         ; EtapaAtual ; Template ; Data1           ; Data2           ; Data3      ; Data4            ; Data5      ; Desc1                                                                         ; Desc2                                                                         ; Desc3                                                                         ; Desc4                                                                         ; Desc5
LIMEIRA       ; Unimed Limeira               ;0; PADRAO   ; Aguardando      ; Aguardando      ; Aguardando ; Aguardando       ; Aguardando ; -                                                                             ; -                                                                             ; -                                                                             ; -                                                                             ; -
CABEFI        ; Cabefi (Migração: XAMPP --> DOCKER)       ;2; MIGRACAO ;concluido;concluido; Aguardando ; Aguardando       ; -          ; Mapeamento de bibliotecas e preparação do ambiente Linux.                     ;Transformação do monolito XAMPP em imagens Docker isoladas.                   ; Testes de deploy e migração de arquivos web para o novo container.             ; Momento da virada oficial e alteração do tráfego para os novo servidor (apontamento DNS); -
`;

const lines = csvData.split('\n');
for (let i = 1; i < lines.length; i++) {
    if (!lines[i].trim()) continue;
    const row = lines[i].split(';');
    console.log(`LINHA ${i}: Token=${row[0].trim()}, Nome=${row[1].trim()}, columns=${row.length}`);
    for(let j=9; j<14; j++) {
        if(row[j]) console.log(`  Desc${j-8}: ${row[j].trim()}`);
    }
}
