param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ToolName
)

$storagePath = Join-Path $PSScriptRoot 'opt-storage/paths.txt'
if (Test-Path $storagePath) {
    $line = Get-Content $storagePath | Where-Object { $_ -match "^$ToolName\s*," }
    if ($line) {
        if ($line -match '^\s*([^,]+)\s*,\s*(.+)$') {
            $name = $matches[1].Trim()
            $path = $matches[2].Trim()
            Write-Host "$name" -ForegroundColor Cyan -NoNewline
            Write-Host " : " -NoNewline
            Write-Host "$path" -ForegroundColor Yellow
        } else {
            Write-Host $line
        }
    } else {
        Write-Host "Tool not found: $ToolName" -ForegroundColor Red
    }
} else {
    Write-Host "No paths.txt found." -ForegroundColor Red
}