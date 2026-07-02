# Verifica input1: compila y muestra salida esperada via API (simulador)
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

Write-Host "=== 1. Compilar con a.exe (genera .s, NO ejecuta) ===" -ForegroundColor Cyan
.\a.exe inputs\input1.txt
Write-Host "Archivo generado: inputs\input1.s"
Write-Host ""

Write-Host "=== 2. Salida esperada al EJECUTAR el programa ===" -ForegroundColor Cyan
Write-Host "20"
Write-Host "10"
Write-Host "1000000"
Write-Host ""

Write-Host "=== 3. Compilar via app web (API) ===" -ForegroundColor Cyan
$code = [string](Get-Content "inputs\input1.txt" -Raw -Encoding UTF8)
$body = @{ code = $code; optimize = $true } | ConvertTo-Json -Compress
try {
    $r = Invoke-RestMethod "http://127.0.0.1:5002/api/compile" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 15
    if ($r.success) {
        Write-Host "API OK - compilo correctamente" -ForegroundColor Green
        Write-Host "Tokens: $($r.tokens.Count) | Instrucciones: $($r.stats.optimizedInstructions)"
        Write-Host ""
        Write-Host "Abre http://127.0.0.1:5002 -> pestaña Simulacion -> Run para ver 20, 10, 1000000"
    } else {
        Write-Host "Error compilacion: $($r.error)" -ForegroundColor Red
    }
} catch {
    Write-Host "No se pudo conectar al servidor." -ForegroundColor Red
    Write-Host "En OTRA terminal ejecuta:"
    Write-Host "  cd simulador_completo\backend"
    Write-Host "  python server.py"
    Write-Host "Luego abre http://127.0.0.1:5002 (NO abras index.html directo)"
}
