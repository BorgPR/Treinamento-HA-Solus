$files = Get-ChildItem -Filter *.html
$responsive = @"

        /* Responsividade Global Solus HA */
        @media (max-width: 1100px) {
            header { padding: 0.9rem 1rem !important; flex-direction: column !important; gap: 1rem !important; text-align: center; }
            nav { flex-wrap: wrap !important; justify-content: center !important; gap: 0.5rem !important; }
            main, .main-container, .container, .cards-section { padding: 1rem !important; }
            .hero { padding: 3rem 1rem 2rem !important; }
            .hero h1 { font-size: 2.2rem !important; }
            .hero-stats { gap: 1.5rem !important; }
            .grid-layout, .cards-grid, .kanban-board, .cron-grid { grid-template-columns: 1fr !important; gap: 1rem !important; }
            .sidebar, .control-panel, aside { position: static !important; width: 100% !important; order: 2 !important; margin-top: 1rem !important; }
            .diagram-area, .simulation-canvas, .diagram-canvas, .diagram { overflow-x: auto !important; justify-content: flex-start !important; padding: 40px 10px !important; }
            .gateway-container, .zone, .nodes-container, .shared-volume, .cluster-row { min-width: 800px !important; }
            .toolbar { flex-direction: column !important; align-items: flex-start !important; }
            .view-toggles { width: 100% !important; flex-wrap: wrap !important; }
        }
"@

foreach ($file in $files) {
    if ($file.Name -eq "fix_responsive.ps1") { continue }
    $content = Get-Content $file.FullName -Raw
    if ($content -match "/\* Responsividade Global Solus HA \*/") {
        Write-Host "Already updated $($file.Name)"
        continue
    }
    if ($content -match "</style>") {
        $newContent = $content -replace "</style>", ($responsive + "`r`n    </style>")
        Set-Content $file.FullName $newContent -Encoding utf8
        Write-Host "Updated $($file.Name)"
    }
}
