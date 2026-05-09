@echo off
title MobileAgent - 一键启动
cd /d "%~dp0"

echo ========================================
echo   MobileAgent 一键启动
echo   基于 mobileCodexHelper 修改
echo ========================================
echo.

REM 1. Start Node.js server
echo [1/3] 启动 Node 服务 (端口 3001)...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue; ^
   if ($p) { Write-Host '  Node 服务已在运行，跳过' } else { ^
     Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File scripts\start-mobile-codex.ps1' -WindowStyle Hidden; ^
     Write-Host '  Node 服务已启动' }"

REM 2. Start nginx
echo [2/3] 启动 nginx 代理 (端口 8080)...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue; ^
   if ($p) { Write-Host '  nginx 已在运行，跳过' } else { ^
     & scripts\start-mobile-codex-nginx.ps1; ^
     Write-Host '  nginx 已启动' }"

REM 3. Start control tool
echo [3/3] 启动桌面控制工具...
start python mobile_codex_control.py

echo.
echo 正在验证服务状态...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try {  = Invoke-RestMethod http://127.0.0.1:3001/api/auth/status -TimeoutSec 5; ^
   Write-Host '  Node 服务: OK' -ForegroundColor Green } catch { Write-Host '  Node 服务: 未就绪' -ForegroundColor Yellow }"
echo.
echo ========================================
echo   本地地址: http://127.0.0.1:3001
echo   远程地址: 查看控制工具窗口
echo.
echo   服务已在后台运行。
echo ========================================
echo.
echo 按任意键关闭本窗口 ^(服务继续运行^)...
pause >nul
