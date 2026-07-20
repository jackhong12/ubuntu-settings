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

`zlib.zsh` is the entry point. It defines `zinclude <file>` and `zinclude_all`, which load files from `~/.zsh/zlib/` (a symlink to `zsh/lib/` created by `zsh/install.sh`).

During install, `zsh/install.sh` generates `~/.zshrc` which exports `ZSH_LIB_PATH` pointing to the repo's `zsh/lib/` directory.

Each library file guards against double-sourcing with:
```zsh
if [[ -v __INCLUDE_<NAME>_ZSH__ ]]; then
  return 0
else
  __INCLUDE_<NAME>_ZSH__=1
fi
```

### Key helpers

- `prun <cmd>` — print command in green, then execute it
- `git_is` — returns 0 if inside a git repo
- `vime` — open all modified files (`git status`) in vim; falls back to Perforce `p4 opened`
- `vimp` — open files changed in the previous commit (`git diff-tree HEAD`)
- `tproject` — tmux project launcher (requires `TPROJECT_ENABLE=1`)

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
