$f = 'projetos.html'
$bytes = [IO.File]::ReadAllBytes($f)
$c = [Text.Encoding]::UTF8.GetString($bytes)
$idx = $c.IndexOf("Sincronizac")
if ($idx -ge 0) {
    $excerpt = $c.Substring($idx - 20, 60)
    $b = [Text.Encoding]::UTF8.GetBytes($excerpt)
    Write-Host "Hex:"
    $b | ForEach-Object { "{0:X2}" -f $_ } | Write-Host
    Write-Host "String: [$excerpt]"
} else {
    Write-Host "Nao encontrado"
}
