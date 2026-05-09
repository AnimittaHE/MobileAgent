@echo off
title MobileAgent - Start
cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start-all.ps1"
pause
