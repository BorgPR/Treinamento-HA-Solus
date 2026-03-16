$files = @("glusterfs.html","visaogeral_projetos.html","projetos.html","gerenciamento.html")

foreach ($f in $files) {
    $p = Join-Path (Get-Location) $f
    if (-not (Test-Path $p)) { continue }
    $bytes = [IO.File]::ReadAllBytes($p)
    $c = [Text.Encoding]::UTF8.GetString($bytes)
    $orig = $c

    # Build replacement pairs using char codes to avoid encoding issues in script file
    $A = [char]0xC3
    $pairs = @(
        # Multi-char sequences first (order matters!)
        @([string]($A + [char]0xA7 + $A + [char]0xA3 + 'o'), "c" + [char]0xE3 + "o"),   # cao -> cão
        @([string]($A + [char]0xA7 + $A + [char]0xB5 + 'es'), "c" + [char]0xF5 + "es"), # coes -> ções
        @([string]($A + [char]0xA7 + $A + [char]0xA3), "c" + [char]0xE7 + "a"),         # ca -> ça
        @([string]("SIMULA" + $A + [char]0x87 + $A + [char]0x83 + "O"), "SIMULA" + [char]0xC7 + [char]0xC3 + "O"),   
        @([string]("SA" + $A + [char]0x9A + "DE"), "SA" + [char]0xDA + "DE"),
        @([string]($A + "rea"), [char]0xC1 + "rea"),
        # Single char sequences
        @([string]($A + [char]0xA7), [string][char]0xE7),  # c-cedilla
        @([string]($A + [char]0xA3), [string][char]0xE3),  # a-tilde
        @([string]($A + [char]0xB5), [string][char]0xF5),  # o-tilde
        @([string]($A + [char]0xA9), [string][char]0xE9),  # e-acute
        @([string]($A + [char]0xA1), [string][char]0xE1),  # a-acute
        @([string]($A + [char]0xAA), [string][char]0xEA),  # e-circumflex
        @([string]($A + [char]0xB3), [string][char]0xF3),  # o-acute
        @([string]($A + [char]0xB4), [string][char]0xF4),  # o-circumflex
        @([string]($A + [char]0xA2), [string][char]0xE2),  # a-circumflex
        @([string]($A + [char]0xBA), [string][char]0xFA),  # u-acute
        @([string]($A + [char]0xAD), [string][char]0xED),  # i-acute
        @([string]($A + [char]0x87), [string][char]0xC7),  # C-cedilla
        @([string]($A + [char]0x9A), [string][char]0xDA),  # U-acute
        @([string]($A + [char]0x89), [string][char]0xC9),  # E-acute
        @([string]($A + [char]0x80), [string][char]0xC0),  # A-grave
        @([string]($A + [char]0x83), [string][char]0xC3),  # A-tilde
        @([string]($A + [char]0x95), [string][char]0xD5),  # O-tilde
        @([string]([char]0xC2 + [char]0xAB), [string][char]0xAB),  # guillemets
        @([string]([char]0xE2 + [char]0x80 + [char]0x94), [string][char]0x2014)  # em dash
    )

    foreach ($pair in $pairs) {
        $c = $c.Replace($pair[0], $pair[1])
    }

    if ($c -ne $orig) {
        [IO.File]::WriteAllText($p, $c, [Text.Encoding]::UTF8)
        Write-Host "Corrigido: $f"
    } else {
        Write-Host "Sem alteracoes: $f"
    }
}
Write-Host "Concluido!"
