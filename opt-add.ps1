param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$ScriptName,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Path
)

Write-Host "opt-add: " -ForegroundColor Green -NoNewline
Write-Host "Adding tool: " -NoNewline
Write-Host "$ScriptName" -ForegroundColor Cyan

try {
    # Determine script directory
    $ScriptPath = $MyInvocation.MyCommand.Path
    if ([string]::IsNullOrEmpty($ScriptPath)) {
        $ScriptDirectory = Get-Location
    } else {
        $ScriptDirectory = Split-Path -Parent $ScriptPath
    }

    # Create opt-storage only if it doesn't exist
    $optDir = Join-Path $ScriptDirectory "opt-storage"

    if (-not (Test-Path $optDir)) {
        New-Item -ItemType Directory -Path $optDir | Out-Null
    }

    $PathsFile = Join-Path -Path $ScriptDirectory -ChildPath "opt-storage/paths.txt"

    # Normalize script name
    $ScriptName = $ScriptName.Trim()
    if ($ScriptName.EndsWith(".ps1", [System.StringComparison]::InvariantCultureIgnoreCase)) {
        $ScriptName = $ScriptName.Substring(0, $ScriptName.Length - 4)
    }

    # Normalize and resolve path
    $Path = $Path.Trim()
    if (-not ([System.IO.Path]::IsPathRooted($Path))) {
        # Resolve relative path to absolute based on current location
        $ResolvedPath = Resolve-Path -Path $Path -ErrorAction Stop
        $Path = $ResolvedPath.Path
    } else {
        # Ensure proper canonical path
        $Path = [System.IO.Path]::GetFullPath($Path)
    }

    $newEntry = "$ScriptName, $Path"

    # Read existing file safely, normalize lines
    $lines = @()
    if (Test-Path $PathsFile) {
        $lines = Get-Content $PathsFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    }

    # Check for existing entry (case-insensitive)
    $exists = $lines | Where-Object { ($_ -split ',',2)[0].Trim() -ieq $ScriptName }

    if ($exists) {
        Write-Host "Failed: Entry for '$ScriptName' already exists." -ForegroundColor Red
        Write-Host "Use opt-remove.ps1 to remove it first." -ForegroundColor Yellow
        exit 1
    }

    # Append new entry in-memory
    $lines += $newEntry

    # Sort by ScriptName (case-insensitive)
    $lines = $lines | Sort-Object { ($_ -split ',',2)[0].Trim().ToLower() }

    # Write back everything with exactly one line per entry
    $lines | Set-Content -Path $PathsFile -Encoding utf8

    Write-Host "Added entry:" -ForegroundColor Green
    if ($ScriptName -and $Path) {
        Write-Host "  " -NoNewline
        Write-Host "$ScriptName" -ForegroundColor Cyan -NoNewline
        Write-Host " : " -NoNewline
        Write-Host "$Path" -ForegroundColor Yellow
    } else {
        Write-Host "  $newEntry" -ForegroundColor Green
    }
    
    $GenerateScript = Join-Path -Path $ScriptDirectory -ChildPath "opt-generate.ps1"
    if (Test-Path $GenerateScript) {
        Write-Host "Running opt-generate.ps1 to update toggle scripts..." -ForegroundColor Cyan
        & $GenerateScript
    } else {
        Write-Host "opt-generate.ps1 not found. Skipping toggle script generation." -ForegroundColor Yellow
    }
    # Write-Host "Run opt-generate.ps1 to create toggle scripts." -ForegroundColor Cyan

} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
