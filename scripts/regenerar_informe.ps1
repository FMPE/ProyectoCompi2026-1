#!/usr/bin/env pwsh
# Regenera benchmarks, gráficos, screenshots e Informe.pdf
$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root
$env:Path = "C:\msys64\ucrt64\bin;$env:USERPROFILE\.cargo\bin;" + $env:Path

$py = "py"
if (-not (Get-Command py -ErrorAction SilentlyContinue)) { $py = "python" }

Write-Host "=== Benchmarks ===" -ForegroundColor Cyan
& $py -3 benchmarks/run_benchmark.py

Write-Host "=== Assets (tablas + graficos) ===" -ForegroundColor Cyan
& $py -3 scripts/generate_report_assets.py

Write-Host "=== Screenshots (servidor en :5002) ===" -ForegroundColor Cyan
try {
    & $py -3 scripts/capture_screenshots.py
} catch {
    Write-Host "AVISO: Sin screenshots. Inicia: cd simulador_completo/backend; py -3 server.py" -ForegroundColor Yellow
}

Write-Host "=== Informe.pdf ===" -ForegroundColor Cyan
& $py -3 scripts/generate_informe.py

Write-Host "`nListo: Informe.pdf + docs/assets/" -ForegroundColor Green
