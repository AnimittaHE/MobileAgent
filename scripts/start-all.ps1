$workspace = Split-Path -Parent $PSScriptRoot
$ErrorActionPreference = 'Continue'

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MobileAgent - One-Click Start" -ForegroundColor Cyan
Write-Host "  Based on mobileCodexHelper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Start Node.js server
Write-Host "[1/3] Starting Node server (port 3001)..." -ForegroundColor White
$existingApp = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue
if ($existingApp) {
    Write-Host "  Node server already running, skip" -ForegroundColor Gray
} else {
    Start-Process -FilePath 'powershell' -ArgumentList @(
        '-NoProfile', '-ExecutionPolicy', 'Bypass',
        '-File', (Join-Path $workspace 'scripts\start-mobile-codex.ps1')
    ) -WindowStyle Hidden
    Write-Host "  Node server started (background)" -ForegroundColor Green
    Start-Sleep -Seconds 3
}

# 2. Start nginx
Write-Host "[2/3] Starting nginx proxy (port 8080)..." -ForegroundColor White
$existingNginx = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
if ($existingNginx) {
    Write-Host "  nginx already running, skip" -ForegroundColor Gray
} else {
    try {
        & (Join-Path $workspace 'scripts\start-mobile-codex-nginx.ps1')
        Write-Host "  nginx started" -ForegroundColor Green
    } catch {
        Write-Host "  nginx start failed: $_" -ForegroundColor Red
    }
}

# 3. Start control tool
Write-Host "[3/3] Starting desktop control tool..." -ForegroundColor White
$controlScript = Join-Path $workspace 'mobile_codex_control.py'
if (Test-Path $controlScript) {
    Start-Process python -ArgumentList $controlScript
    Write-Host "  Control tool started" -ForegroundColor Green
} else {
    Write-Host "  Control tool script not found: $controlScript" -ForegroundColor Yellow
}

# Verify service
Write-Host ""
Write-Host "Checking service status..." -ForegroundColor White
Start-Sleep -Seconds 2
try {
    $res = Invoke-RestMethod -Uri "http://127.0.0.1:3001/api/auth/status" -TimeoutSec 5
    Write-Host "  Node service: OK" -ForegroundColor Green
} catch {
    Write-Host "  Node service: not ready (may still be starting)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Local:  http://127.0.0.1:3001" -ForegroundColor White
Write-Host "  Remote: check the control tool window" -ForegroundColor White
Write-Host ""
Write-Host "  Services are running in background." -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to close this window (services keep running)..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
