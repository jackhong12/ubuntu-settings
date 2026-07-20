# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Conventions

- Indent with **2 spaces** (zsh, PowerShell, shell scripts)
- Write code and comments in **English**

## Repository layout

Each top-level directory is a self-contained component with its own `install.sh` (or `install.ps1`):

| Directory | Purpose |
|-----------|---------|
| `zsh/` | Zsh config — `.zshrc` + a library of sourced helpers in `zsh/lib/` |
| `posh/` | PowerShell (Windows) equivalent — `profile.ps1` + helpers in `posh/lib/` |
| `tmux/` | tmux config |
| `fonts/` | Nerd Font installers |
| `nvm/` | nvm bootstrap |
| `gdb/` | `.gdbinit` |
| `tools/` | Misc CLI tools (pre-commit hook, zsh-help) |
| `docker/` | Dockerfiles for test environments |

## Installation

```bash
# Install everything (from repo root)
bash install.sh

# Install a single component
cd zsh && zsh install.sh
cd tmux && zsh install.sh
```

PowerShell (Windows, run from repo root in an elevated prompt):
```powershell
.\posh\install.ps1
```

## Zsh library system (`zsh/lib/`)

`zlib.zsh` is the entry point. It defines `zinclude <file>` and `zinclude_all`,
which load files from `ZSH_LIB_PATH` (a semicolon-separated list of directories,
similar to `PATH`).

`zlib.zsh` is self-bootstrapping: on load it prepends its own directory to
`ZSH_LIB_PATH` via `$0`, so it works even if `ZSH_LIB_PATH` is not pre-set.

`zsh/install.sh` generates `~/.zshrc` which:
1. Exports `ZSH_LIB_PATH` pointing to the repo's `zsh/lib/`
2. Sources `zlib.zsh`
3. Calls `zinclude_all` to load all lib files
4. Sources `zsh/.zshrc` for the rest of the shell config

Include guards are stored as global variables named `__INCLUDE_<NAME>_ZSH__`,
whose value is the full path of the sourced file (useful for debugging with
`zlib_list`).

### Key helpers

- `prun <cmd>` — print command in green, then execute it
- `git_is` — returns 0 if inside a git repo
- `vime` — open all modified files (`git status`) in vim; falls back to Perforce `p4 opened`
- `vimp` — open files changed in the previous commit (`git diff-tree HEAD`)
- `tproject` — tmux project launcher (requires `TPROJECT_ENABLE=1`)
- `zlib_list` — print all currently sourced zlib files
- `zlib_path` — print `ZSH_LIB_PATH`
- `zlib_repo_path` — print the repo root (derived from `zlib.zsh`'s own location)

## PowerShell library system (`posh/lib/`)

`posh/install.ps1` rewrites `$PROFILE` to set `$PoshDir` and dot-source `profile.ps1`.  
`profile.ps1` dot-sources each file in `posh/lib/` explicitly.

When adding a new `posh/lib/*.ps1`, register it in `profile.ps1` with:
```powershell
. "$PoshDir\lib\<name>.ps1"
```

Local machine overrides go in `~/local.ps1` (not tracked).

## Local overrides

- Zsh: `~/.local.zsh` — sourced last by `.zshrc`
- PowerShell: `~/local.ps1` — sourced last by `profile.ps1`
