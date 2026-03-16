$htmls = Get-ChildItem -Filter "*.html"
foreach ($f in $htmls) {
    $content = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8)
    $lines = $content -split "`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        # Check for corrupted patterns
        if ($line -match 'Ã|â€|âœ|â„|ac[^çãa-zA-Z0-9]|ac$|ac<') {
            Write-Host "$($f.Name):$($i+1): $($line.Trim())"
        }
    }
}
