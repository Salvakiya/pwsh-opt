# PWSH-OPT PowerShell Script Generator

This repository contains a PowerShell utility that generates small **“toggle scripts”**, each capable of adding or removing a specific directory from your system `PATH` at runtime for your **current session only**.

This makes it easy to quickly switch between different toolchains, SDKs, compilers, or utilities without permanently modifying your global environment variables.

---

## ✨ Features

* Reads a list of *script name + filesystem path* entries from `paths.txt`.
* Generates individual `.ps1` toggle scripts for each path.
* Each toggle script:
  * **Adds** its path to the beginning of `PATH` if missing.
  * **Removes** it from `PATH` if already present.
* Case-insensitive path matching.
* Normalizes paths by trimming whitespace and trailing slashes.
* Resolves relative paths to absolute paths automatically.
* Prevents duplicate entries.
* Automatically names generated scripts based on your input file.
* Sorts entries alphabetically by `ScriptName`.
* Automatically runs `opt-generate.ps1` after adding a new path.

---

## 📁 Repository Structure

```
/pwsh-opt
   paths.txt
   opt-add.ps1      (add entries safely)
   opt-generate.ps1 (generates toggle scripts)
   <generated scripts appear here>
```

---

## 📝 The `paths.txt` Format

Each line follows this format:

```
scriptName, path-to-directory
```

### Example

```
mingw64, C:\Dev\mingw64\bin
clang,   C:\Tools\LLVM\bin
python311, C:\Python311
```

* The **name before the comma** becomes the script filename with opt-toggle- prepended (`opt-toggle-mingw64.ps1`, `clang.ps1`, etc.).
* The **path after the comma** is the directory to toggle in `PATH`.
* Blank lines are ignored.
* Relative paths are automatically resolved to absolute paths.
* Entries are sorted alphabetically.

---

## ▶️ Usage

### 1. Add a new path

Use `opt-add.ps1` to append a new entry easily:

```powershell
.\opt-add.ps1 node18 "C:\Tools\node18"
```

* Each entry is automatically normalized and resolved. If the repository directory is in your PATH you can do opt-add cmake . when in the cmake directory to add that directory as an entry.
* Duplicate script names are prevented.
* `opt-generate.ps1` is run automatically after adding an entry.

---

### 2. Run the generator manually

If you edit `paths.txt` directly:

```powershell
.\opt-generate.ps1
```

The script:

* Reads `paths.txt`
* Generates one `.ps1` toggle script per entry
* Writes them in the same directory as `opt-generate.ps1`

Example output:

```
Generated script: C:\repo\opt-toggle-node18.ps1 at c:\tools\node18
Generated script: C:\repo\opt-toggle-node20.ps1 at c:\tools\node20
```

---

## 🔀 Using the Generated Toggle Scripts

Each generated script toggles **its own path** in the current PowerShell session.

Example:

```powershell
.\opt-toggle-node18.ps1
```

* If the path was *not* previously in `PATH`:

```
Prepended 'c:\tools\node18' to PATH.
```

* Running it again:

```
Removed 'c:\tools\node18' from PATH.
```

> Changes affect **only the current PowerShell session** and do **not** alter the system or user PATH permanently.

---

## 🧹 Path Normalization Rules

Before embedding into the generated script:

* Leading/trailing whitespace is trimmed
* Trailing slashes/backslashes (`/` or `\`) are removed
* Relative paths are resolved to absolute paths
* Path comparison is case-insensitive
* Single quotes are escaped for PowerShell safety

---

## 🛠 Requirements

* Windows PowerShell 5.x **or** PowerShell 7+
* Execution policy that allows local scripts:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 📚 Why This Exists

This utility is ideal for developers who frequently switch environments:

* Multiple compilers (MSVC ↔ MinGW ↔ Clang)
* Multiple Node, Python, or Java versions
* Multiple SDK or tool directories
* Temporary debugging environments

It ensures you can swap paths quickly and cleanly **without editing Windows environment variables or restarting**.
