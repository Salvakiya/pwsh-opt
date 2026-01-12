# Get the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find all files starting with "opt-toggle"
Get-ChildItem -Path $scriptDir -Filter "opt-toggle*" | Select-Object -ExpandProperty Name