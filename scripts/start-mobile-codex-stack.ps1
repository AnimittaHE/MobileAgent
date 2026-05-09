$workspace = Split-Path -Parent $PSScriptRoot

$existingApp = Get-NetTCPConnection -LocalAddress '127.0.0.1' -LocalPort 3001 -State Listen -ErrorAction SilentlyContinue
if (-not $existingApp) {
  Start-Process -FilePath 'powershell' -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $workspace 'scripts\start-mobile-codex.ps1')) -WindowStyle Hidden | Out-Null
  Start-Sleep -Seconds 5
} else {
  Write-Host 'Mobile Codex app is already listening on 127.0.0.1:3001'
}
powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $workspace 'scripts\start-mobile-codex-nginx.ps1') | Out-Null
