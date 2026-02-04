## opt: PowerShell Toolchain Path Manager

Quickly add, remove, list, and toggle toolchain paths for your current PowerShell session.

---

### Install
git clone this repository
set the root of this repoitory to your system path for easier usage.


### Usage

See all commands and usage:

```powershell
./opt-help.ps1
```

**Common commands:**

```powershell
./opt-add.ps1 <tool> <path>      # Add a tool and its path
./opt-list.ps1                   # List all tools and their paths
./opt-remove.ps1 <tool>          # Remove a tool and its toggle script
./opt-show.ps1 <tool>            # Show the path of a specific tool
./opt-generate.ps1               # Regenerate toggle scripts from paths.txt
```

Toggle a tool's path in your session:

```powershell
./opt-toggle-<tool>.ps1
```

---

**All changes affect only the current PowerShell session.**
