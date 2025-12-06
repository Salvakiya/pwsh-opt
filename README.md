# PWSH-OPT powershell script generator

This repository contains a PowerShell utility that generates small “toggle scripts,” each capable of adding or removing a specific directory from your system `PATH` at runtime for your current session.

This makes it easy to quickly switch between different toolchains, SDKs, compilers, or utilities without permanently modifying your global environment variables.

---

## ✨ Features

* Reads a list of *script name + filesystem path* entries.
* Generates individual `.ps1` toggle scripts for each path.
* Each toggle:
  * **Adds** its path to the beginning of `PATH` if missing.
  * **Removes** it from `PATH` if already present.
* Case-insensitive path matching.
* Normalizes paths by trimming whitespace and trailing slashes.
* Prevents duplicate entries.
* Automatically names generated scripts based on your input file.

---

## 📁 Repository Structure

```
/pwsh-opt
   paths.txt
   generate.ps1   (this script)
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

* The name before the comma becomes the **script filename** (`mingw64.ps1`, `clang.ps1`, etc.).
* The path after the comma is the **directory to toggle** in your `PATH`.

Blank lines are ignored.

---

## ▶️ Usage

### 1. Edit `paths.txt`

Add one entry per toggle script you want to generate.

Example:

```
node18, C:\Tools\node18
node20, C:\Tools\node20
```

### 2. Run the generator

From PowerShell:

```powershell
.\generate.ps1
```

The script:

* Reads `paths.txt`
* Generates one `.ps1` script for each entry
* Writes them in the same directory as `generate.ps1`

You should see output like:

```
Generated script: C:\repo\node18.ps1 at c:\tools\node18
Generated script: C:\repo\node20.ps1 at c:\tools\node20
```

---

## 🔀 Using the Generated Toggle Scripts

Each generated script toggles **its** path inside your current PowerShell session.

Example:

```powershell
.\node18.ps1
```

If the path was *not* previously in `PATH`:

```
Prepended 'c:\tools\node18' to PATH.
```

Run it again:

```
Removed 'c:\tools\node18' from PATH.
```

### Note

Changes affect **only the current PowerShell session** and do not alter the system or user PATH permanently.

---

## 🧹 Path Normalization Rules

Before embedding into the generated script:

* Leading/trailing whitespace is trimmed
* Trailing slashes/backslashes (`/` or `\`) are removed
* Path is lowercased for consistent comparison
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
* Multiple Node, Python, Java versions
* Multiple SDK or tool directories
* Temporary debugging environments

It ensures you can swap paths quickly and cleanly without editing the Windows environment variable UI or restarting anything.
