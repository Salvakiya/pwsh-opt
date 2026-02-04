Write-Host "======================" -ForegroundColor Green
Write-Host "       opt-list       " -ForegroundColor Green
Write-Host "======================" -ForegroundColor Green

$storagePath = Join-Path $PSScriptRoot 'opt-storage/paths.txt'
if (Test-Path $storagePath) {
    Get-Content $storagePath | ForEach-Object {
        if ($_ -match '^\s*([^,]+)\s*,\s*(.+)$') {
            $name = $matches[1].Trim()
            $path = $matches[2].Trim()
            Write-Host "$name" -ForegroundColor Cyan -NoNewline
            Write-Host " : " -NoNewline
            Write-Host "$path" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "No tools found."
}