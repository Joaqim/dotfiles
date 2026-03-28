# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS flake-based configuration repository (dotfiles) using a modular architecture with both NixOS system configurations and home-manager user configurations. The repository manages multiple hosts (desktop, deck, qb, raket) and supports containerized home environments.

## Key Commands

**Development workflow:**

- `task test` or `task dry-activate` - Dry-run both NixOS and home-manager changes
- `task test-nixos` - Build NixOS config without applying (no root required)
- `task test-home-manager` - Dry-run home-manager activation
- `nix flake check -L` - Check flake for errors

**Applying changes:**

- `task nixos` or `task switch` - Apply NixOS configuration (requires `/etc/NIXOS`)
- `task home-manager` or `task hm` - Apply home-manager for current user@host
- `task apply` - Apply both NixOS and home-manager ( should only be run if
  explicitly stated by user )

**Committing changes:**

- `task commit` - Smart commit that auto-fixes formatting and retries (recommended)
- `./scripts/git-smart-commit.sh -m "message"` - Direct script usage
- `git commit` - Standard commit (may require manual restaging if formatters modify files)
- `task format` - Manually format and re-stage files before commit

**Maintenance:**

- `task update` - Update flake.lock, run selfup, and nvfetcher
- `task pre-commit-all` - Run pre-commit hooks including auto-formatting
- `task check` - Run `nix flake check`

**Home-manager specifics:**

- Use `HM_HOST_SLUG` environment variable (in `.env`) to build for specific host on any machine
- Default config pattern: `${USER}@${HM_HOST_SLUG:-$(hostname)}`

## Architecture

### Module System

The repository uses a custom `my.*` namespace for all options:

**NixOS modules** (`modules/nixos/`):

- `my.profiles.*` - High-level feature bundles (plasma, hyprland, bluetooth, fcitx5, minecraft-server, etc.)
- `my.services.*` - System services configuration
- `my.programs.*` - System-wide programs
- `my.hardware.*` - Hardware-specific configuration
- `my.system.*` - Core system settings
- `my.user.{name, fullName, email}` - Primary user configuration

**Home-manager modules** (`modules/home/`):

- `my.home.*` - User-level programs and configurations
- Automatically imported from all subdirectories in `modules/home/`
- Examples: `my.home.firefox.enable`, `my.home.mpv.enable`, `my.home.gaming.enable`

### Directory Structure

```
.
├── flake/              # Flake composition (outputs, nixos, home-manager, overlays, etc.)
├── hosts/
│   ├── nixos/         # NixOS host configurations (desktop, deck, qb, raket, etc.)
│   └── homes/         # Home-manager configurations (user@host pattern)
├── modules/
│   ├── nixos/         # System-level modules organized by category
│   │   ├── profiles/  # High-level feature bundles
│   │   ├── services/
│   │   ├── programs/
│   │   ├── hardware/
│   │   └── system/
│   └── home/          # User-level home-manager modules (auto-imported)
├── pkgs/              # Custom package definitions
├── overlays/          # Nixpkgs overlays (auto-imported)
├── apps/              # Flake apps (helper scripts)
├── lib/               # Extended Nix library functions
└── secrets/           # Encrypted secrets (sops-nix)
```

### Host Configuration Pattern

Each NixOS host has files like:

- `default.nix` - Base imports and user info
- `profiles.nix` - Enable `my.profiles.*` features
- `services.nix` - Configure `my.services.*`
- `programs.nix` - Configure `my.programs.*`
- `hardware.nix` - Configure `my.hardware.*`
- `boot.nix`, `networking.nix`, `system.nix` - Other system settings

Home-manager configs follow `user@host` pattern (e.g., `jq@desktop`) and enable `my.home.*` modules.

### Flake Inputs

Key external inputs:

- `nixpkgs` - NixOS unstable
- `home-manager` - User environment management
- `sops-nix` - Secrets management
- `disko` - Declarative disk partitioning
- `nvf` - Neovim configuration framework
- `jqpkgs` - Personal package repository
- `nix-minecraft` - Minecraft server management
- Various custom flakes for specific services (alexandria, ccc, jellyfin-plugins, etc.)

## Development Guidelines

### Creating/Modifying Modules

**NixOS modules:**

1. Place in appropriate category under `modules/nixos/`
2. Use `my.*` namespace for all options
3. Use `mkEnableOption` or `mkOption` from `lib`
4. Wrap implementation in `mkIf cfg.enable`
5. For feature bundles, create under `modules/nixos/profiles/`

**Home-manager modules:**

1. Create directory under `modules/home/` (auto-imported)
2. Use `my.home.*` namespace
3. Follow same enable/conditional pattern

### Package Management

**Custom packages:**

- Add to `pkgs/` directory
- Auto-imported and exposed as `pkgs.my.<name>`
- Use `nvfetcher.toml` for packages that need version tracking

**Overlays:**

- Add to `overlays/` directory (auto-imported)
- Modify existing nixpkgs packages here

### Testing Workflow

1. Make changes to modules or configurations
2. Run `task test` to verify both NixOS and home-manager build
3. If only changing home-manager: `task test-hm` is faster
4. Pre-commit hooks run automatically (or manually with `task pre-commit-all`)

### Secrets Management

- Uses sops-nix for encrypted secrets
- Config in `.sops.yaml`
- Secrets stored in `secrets/` directory
- See: https://github.com/getsops/sops/issues/1117#issuecomment-1328336452 for merge conflict handling

## Common Patterns

**Enable a profile for a host:**

```nix
# In hosts/nixos/<hostname>/profiles.nix
my.profiles.plasma.enable = true;
my.profiles.bluetooth.enable = true;
```

**Enable home-manager module:**

```nix
# In hosts/homes/<user>@<host>/default.nix
my.home.firefox.enable = true;
my.home.mpv.enable = true;
```

**Custom package in home config:**

```nix
home.packages = [ pkgs.my.mpv-history-launcher ];
```

## CI/CD

- GitHub Actions workflows in `.github/workflows/`
- `check.yml` - Runs `nix flake check` on Nix file changes
- `ci-home.yml` - Tests home-manager for generic user
- `container.yml` - Builds containerized home environment
