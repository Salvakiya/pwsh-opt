# opt-remove.ps1
# Usage: ./opt-remove.ps1 <toolname>

param(
	[Parameter(Mandatory = $true, Position = 0)]
	[string]$ToolName
)

Write-Host "opt-remove: " -ForegroundColor Green -NoNewline
Write-Host "Removing tool: " -NoNewline
Write-Host "$ToolName" -ForegroundColor Cyan

$storagePath = Join-Path $PSScriptRoot 'opt-storage/paths.txt'
$toggleScript = Join-Path $PSScriptRoot ("opt-toggle-$ToolName.ps1")

# Remove from paths.txt
if (Test-Path $storagePath) {
	$lines = Get-Content $storagePath
	$filtered = $lines | Where-Object { $_ -notmatch "^$ToolName\s*," }
	$filtered | Set-Content $storagePath
	Write-Host "Removed $ToolName from paths.txt." -ForegroundColor Red
} else {
	Write-Warning "Storage file not found: $storagePath"
}

# Remove toggle script if it exists
if (Test-Path $toggleScript) {
	Remove-Item $toggleScript -Force
	Write-Host "Removed toggle script: $toggleScript" -ForegroundColor Red
} else {
	Write-Host "No toggle script found for $ToolName."
}
