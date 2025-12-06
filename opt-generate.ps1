# Get the full path of the current script file
$ScriptPath = $MyInvocation.MyCommand.Path
$ScriptDirectory = Split-Path -Parent $ScriptPath

# Define the filename to append
$FileName = "paths.txt"


$inputFile = Join-Path -Path $ScriptDirectory -ChildPath $FileName


# Read the input file
$lines = Get-Content -Path $inputFile

# Template for the toggle script
$scriptTemplate = @'
$PathToToggle = '{0}'

# Split the current PATH into an array
$paths = $env:PATH -split ';'

# Check if the path is already in the PATH (case-insensitive comparison)
if ($paths -icontains $PathToToggle) {{
    # Remove the path
    $paths = $paths | Where-Object {{ $_ -ine $PathToToggle }}
    $env:PATH = $paths -join ';'
    Write-Host "Removed '$PathToToggle' from PATH." -ForegroundColor Red
}} else {{
    # Prepend the path
    $env:PATH = "$PathToToggle;$env:PATH"
    Write-Host "Prepended '$PathToToggle' to PATH." -ForegroundColor Green
}}
'@

# Process each line and generate a script
foreach ($line in $lines) {
    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    # Split the line into scriptname and path
    $parts = $line -split ',+', 2
    if ($parts.Length -ne 2) {
        Write-Warning "Skipping invalid line: $line"
        continue
    }

    $scriptName = Join-Path -Path $ScriptDirectory -ChildPath ("opt-toggle-"+$parts[0]).Trim()
    $pathToToggle = $parts[1].Trim()

    # Escape single quotes in the path (replace ' with '')
    $pathToToggleEscaped = $pathToToggle.Replace("'", "''").TrimEnd('\/').ToLowerInvariant()

    # Ensure scriptName ends with .ps1
    if (-not $scriptName.EndsWith('.ps1')) {
        $scriptName += '.ps1'
    }

    # Generate the script content
    $scriptContent = $scriptTemplate -f $pathToToggleEscaped

    # Write the script to a file
    Set-Content -Path $scriptName -Value $scriptContent
    Write-Output "Generated script: $scriptName at $pathToToggleEscaped"
}