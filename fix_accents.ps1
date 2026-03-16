$files = @("projetos.html","glusterfs.html","gerenciamento.html")

foreach ($f in $files) {
    $p = Join-Path (Get-Location) $f
    if (-not (Test-Path $p)) { continue }
    $c = [IO.File]::ReadAllText($p, [Text.Encoding]::UTF8)
    $orig = $c

    # Fix "âœ"" which is: C3 A2 C5 93 E2 80 9D
    # = U+00E2 (â) + U+0153 (œ) + U+201D (")
    # This should be U+2714 (✔ heavy check mark)
    $badCheck = [string][char]0x00E2 + [char]0x0153 + [char]0x201D
    $goodCheck = [string][char]0x2714  # ✔
    $c = $c.Replace($badCheck, $goodCheck)

    # Fix "ℹ" which is already correct U+2139 - skip

    # Fix "Sincronizac" -> "Sincronização"  (ção was lost)
    $c = $c.Replace("Sincronizac com", "Sincronização com")

    # Fix SAÃšDE in logo SVG: C3 9A = U+00DA but was read as Ã (C3 83) + control
    # Let's check the actual bytes: SAÃšDE
    # grep showed "SAÃšDE" which in UTF-8 is: 53 41 C3 83 C5 A1 44 45
    # U+00C3 (Ã) + U+0161 (š) + DE  -> should be SAÚDE (U+00DA)
    $badSA = "SA" + [char]0x00C3 + [char]0x0161 + "DE"  # SAÃšDE
    $goodSA = "SA" + [char]0x00DA + "DE"  # SAÚDE
    $c = $c.Replace($badSA, $goodSA)

    if ($c -ne $orig) {
        [IO.File]::WriteAllText($p, $c, [Text.Encoding]::UTF8)
        Write-Host "Corrigido: $f"
    } else {
        Write-Host "Sem alteracoes: $f"
    }
}
Write-Host "Concluido!"
