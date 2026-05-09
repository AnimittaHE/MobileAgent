@echo off
title MobileAgent - 停止服务
cd /d "%~dp0"

echo 正在停止 MobileAgent 服务...

echo [1/3] 停止 Python 控制工具...
taskkill /f /im python.exe 2>nul && echo   已停止 || echo   未在运行

echo [2/3] 停止 nginx...
taskkill /f /im nginx.exe 2>nul && echo   已停止 || echo   未在运行

echo [3/3] 停止 Node 服务...
taskkill /f /im node.exe 2>nul && echo   已停止 || echo   未在运行

echo.
echo ========================================
echo   所有服务已停止
echo ========================================
pause
