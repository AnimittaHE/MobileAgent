# MobileAgent 一键启动脚本
$workspace = Split-Path -Parent $PSCommandPath
Set-Location $workspace

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MobileAgent 一键启动" -ForegroundColor Cyan
Write-Host "  基于 mobileCodexHelper 修改" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Node 服务
Write-Host "[1/3] 启动 Node 服务 (端口 3001)..." -ForegroundColor Yellow
$appRunning = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue
if ($appRunning) {
    Write-Host "  Node 服务已在运行，跳过" -ForegroundColor Green
} else {
    $script = Join-Path $workspace 'scripts\start-mobile-codex.ps1'
    Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File',$script -WindowStyle Hidden
    Write-Host "  Node 服务已启动，等待就绪..." -ForegroundColor Green
    Start-Sleep -Seconds 4
}

# 2. nginx 代理
Write-Host "[2/3] 启动 nginx 代理 (端口 8080)..." -ForegroundColor Yellow
$nginxRunning = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
if ($nginxRunning) {
    Write-Host "  nginx 已在运行，跳过" -ForegroundColor Green
} else {
    $nginxScript = Join-Path $workspace 'scripts\start-mobile-codex-nginx.ps1'
    & $nginxScript
    Write-Host "  nginx 已启动" -ForegroundColor Green
}

# 3. 控制工具
Write-Host "[3/3] 启动桌面控制工具..." -ForegroundColor Yellow
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
    Write-Host "  错误: 未找到 python" -ForegroundColor Red
    Read-Host "按回车退出"
    exit 1
}
Start-Process $pythonCmd.Path -ArgumentList (Join-Path $workspace 'mobile_codex_control.py')

Write-Host ""
Write-Host "正在验证服务状态..." -ForegroundColor DarkGray
try {
    $null = Invoke-RestMethod http://127.0.0.1:3001/api/auth/status -TimeoutSec 5
    Write-Host "  Node 服务: OK" -ForegroundColor Green
} catch {
    Write-Host "  Node 服务: 未就绪" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  本地地址 : http://127.0.0.1:3001" -ForegroundColor White
Write-Host "  远程地址 : 查看控制工具窗口" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "服务已在后台运行，按回车关闭本窗口" -ForegroundColor DarkGray
Read-Host
