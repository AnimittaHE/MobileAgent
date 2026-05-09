$proc = Get-CimInstance Win32_Process -Filter 'Name="node.exe"'
foreach ($p in $proc) {
    Write-Host "PID: $($p.ProcessId)"
    Write-Host "CommandLine: $($p.CommandLine)"
    Write-Host "---"
}

try {
    $r = Invoke-RestMethod http://127.0.0.1:3001/api/auth/status -TimeoutSec 5
    Write-Host "Server status: OK"
} catch {
    Write-Host "Server not reachable"
}
