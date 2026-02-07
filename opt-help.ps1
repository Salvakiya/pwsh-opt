# opt-help.ps1
Write-Host "======================" -ForegroundColor Green
Write-Host "       opt-help       " -ForegroundColor Green
Write-Host "======================" -ForegroundColor Green

Write-Host ""
Write-Host ("{0,-15} {1,-20} {2}" -f "Command", "Arguments", "Description") -ForegroundColor Yellow
Write-Host ("{0,-15} {1,-20} {2}" -f "-------", "---------", "-----------") -ForegroundColor DarkGray

# Helper function for colorized table rows
function Write-HelpRow($cmd, $argsu, $desc) {
    if (-not $argsu) { $argsu = "" }
    Write-Host ("{0,-15}" -f $cmd) -ForegroundColor Cyan -NoNewline
    Write-Host ("{0,-20}" -f $argsu) -ForegroundColor Magenta -NoNewline
    Write-Host $desc -ForegroundColor White
}

Write-HelpRow "opt-add"    "<tool> <path>" "Add a tool and its path"
Write-HelpRow "opt-list"   ""              "List all tools and their paths"
Write-HelpRow "opt-list-active" ""       "List active tools in the PATH environment variable"
Write-HelpRow "opt-remove" "<tool>"        "Remove a tool and its toggle script"
Write-HelpRow "opt-show"   "<tool>"        "Show the path of a specific tool"

Write-Host ""
Write-Host "Examples:" -ForegroundColor Yellow
Write-Host "  opt-add cmake ." -ForegroundColor Gray
Write-Host "  opt-remove cmake" -ForegroundColor Gray
Write-Host "  opt-add cmake C:\cmake\bin" -ForegroundColor Gray
Write-Host "  opt-list" -ForegroundColor Gray
Write-Host "  opt-show python310" -ForegroundColor Gray

Write-Host ""
Write-Host "Use the above commands to manage your tools and their paths." -ForegroundColor Green