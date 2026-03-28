# NixOS Configuration

[![Nix Status](https://github.com/Joaqim/dotfiles/actions/workflows/check.yml/badge.svg?branch=main)](https://github.com/Joaqim/dotfiles/actions/workflows/check.yml?query=branch%3Amain+)
[![Home Manager Status](https://github.com/Joaqim/dotfiles/actions/workflows/ci-home.yml/badge.svg?branch=main)](https://github.com/Joaqim/dotfiles/actions/workflows/ci-home.yml?query=branch%3Amain+)
[![Container Status](https://github.com/Joaqim/dotfiles/actions/workflows/container.yml/badge.svg?branch=main)](https://github.com/Joaqim/dotfiles/actions/workflows/container.yml?query=branch%3Amain+)

A comprehensive, modular NixOS configuration managing multiple hosts with a unified `my.*` namespace. Features declarative system configurations, extensive home-manager modules, custom packages, and containerized environments.

> **⚠️ AI-Generated Documentation Disclaimer**
>
> This README was written by Claude because I was too lazy to document my own config. Most features were adapted from the excellent projects listed in [#inspirations](#-resources--inspiration) below. Everything here is subject to change on a whim as I experiment and break things. Your mileage may vary.

---

## 🚀 Quick Start

### Try It Out (No Installation Required)

Experience this configuration in a containerized environment:

```bash
bash <(curl -fsSL 'https://github.com/Joaqim/dotfiles/raw/refs/heads/main/containers/sandbox-with-ghcr.bash') latest
```

_Note: Container is built for x86-64-linux systems._

### Common Commands

```bash
# Test changes (dry-run)
task test                    # Test both NixOS and home-manager
task test-nixos             # Test NixOS configuration only
task test-home-manager      # Test home-manager only

# Apply changes
task nixos                  # Apply NixOS configuration (requires /etc/NIXOS)
task home-manager           # Apply home-manager for current user@host
task apply                  # Apply both (use with caution)

# Maintenance
task update                 # Update flake.lock and run selfup/nvfetcher
task pre-commit-all        # Run pre-commit hooks and auto-formatting
task check                  # Run nix flake check

# Validation
nix flake check -L         # Check flake for errors
```

## 🏗️ Architecture

### The `my.*` Namespace

All custom options use a unified `my.*` namespace for consistency and clarity:

**NixOS Modules** (`modules/nixos/`):

- `my.profiles.*` - High-level feature bundles (desktop environments, services, hardware)
- `my.services.*` - System services (Jellyfin, Minecraft, Alexandria, Ollama, etc.)
- `my.programs.*` - System-wide program configurations
- `my.hardware.*` - Hardware-specific settings
- `my.system.*` - Core system configuration
- `my.user.{name, fullName, email}` - Primary user metadata

**Home-Manager Modules** (`modules/home/`):

- `my.home.*` - User-level programs and configurations (48+ modules)
- Auto-imported from all subdirectories

### Directory Structure

```
dotfiles/
├── flake/                  # Flake composition and outputs
├── hosts/
│   ├── nixos/             # System configurations (desktop, deck, qb, raket, etc.)
│   └── homes/             # User configurations (user@host pattern)
├── modules/
│   ├── nixos/             # System-level modules
│   │   ├── profiles/      # Feature bundles (11 profiles)
│   │   ├── services/      # Service modules (27 services)
│   │   ├── programs/      # Program configurations
│   │   ├── hardware/      # Hardware support
│   │   └── system/        # Core system settings
│   └── home/              # User-level modules (48 modules, auto-imported)
├── pkgs/                  # Custom packages (9 packages)
├── overlays/              # Nixpkgs overlays (auto-imported)
├── apps/                  # Flake apps (helper scripts)
├── lib/                   # Extended Nix library functions
└── secrets/               # Encrypted secrets (sops-nix)
```

## 🖥️ Managed Hosts

### NixOS Systems

- **desktop** - Main workstation with Plasma desktop, Minecraft server, full gaming setup
- **deck** - Steam Deck configuration with Jovian-NixOS integration
- **qb** - Minimal system configuration
- **raket** - Additional host configuration
- **container** - Base NixOS for containerized testing
- **generic** - Generic configuration template

### Home Configurations

- `jq@desktop` - Primary desktop user environment
- `jq@qb` - Minimal home configuration
- `deck@deck` - Steam Deck user setup
- `wilton@raket` - Alternative user configuration
- `user@container` - Containerized home environment
- `github-actions@generic` - CI/CD testing environment

## ✨ Features

### Desktop Environments

- **KDE Plasma** (`my.profiles.plasma`) - Full-featured desktop with customizations
- **Hyprland** (`my.profiles.hyprland`) - Wayland compositor configuration

### Gaming

- **Steam Deck** (`my.profiles.steam-deck`) - Jovian-NixOS integration for Steam Deck hardware
- **Minecraft Servers** - Multiple server configurations with nix-minecraft
  - Vanilla server (`my.profiles.minecraft-server`)
  - Modded server (`my.profiles.minecraft-server-lucky-world-invasion`)
- **Gaming Suite** (`my.home.gaming`) - Gaming tools and optimizations

### Development & Tools

- **Neovim** (`my.home.nvf`) - nvf framework with extensive plugin support
- **Pai** (`my.programs.pai`) - Personal AI Agent
- **VSCode** (`my.home.vscode`) - Visual Studio Code configuration
- **Command Line** (`my.home.command-line`) - Comprehensive CLI toolkit:
  - Modern alternatives: `bat`, `eza`, `fd`, `ripgrep`, `bottom`
  - Shell enhancements: `starship`, `atuin`, `zoxide`, `fzf`, `direnv`
  - Terminal multiplexers: `zellij`
  - Alternative shells: `nushell`

### Services & Infrastructure

- **Alexandria** (`my.services.alexandria`) - Semantic code search for AI agents
- **Jellyfin** (`my.services.jellyfin`) - Media server
- **Ollama** (`my.services.ollama`) - Local LLM inference
- **Open WebUI** (`my.services.open-webui`) - Web interface for LLMs
- **Qdrant** (`my.services.qdrant`) - Vector database for semantic search
- **Atuin Server** (`my.services.atuin-server`) - Shell history sync server
- **Caddy/Nginx** - Reverse proxy and web server
- **Tailscale** - VPN mesh networking
- **Syncthing** - File synchronization
- **QBittorrent** - Torrent client with cross-seed support

### Media & Content

- **MPV** (`my.home.mpv`) - Feature-rich video player with custom scripts:
  - `mpv-skipsilence` - Skip silent parts
  - `mpv-org-history` - Small plugin to store entries as org-compatible text
- **Firefox** (`my.home.firefox`) - Customized browser configuration
- **OBS Studio** (`my.home.obs-studio`) - Streaming and recording
- **yt-dlp** (`my.home.yt-dlp`) - YouTube and media downloader
- **Calibre** (`my.home.calibre`) - E-book management
- **Zathura** (`my.home.zathura`) - Minimalist PDF viewer

### Input & Localization

- **fcitx5** (`my.profiles.fcitx5`) - Advanced input method framework
- **XKB** (`my.profiles.xkb`) - Custom keyboard layouts (US/SE with Dvorak Programmer option)
- **Language** (`my.profiles.language`) - Multi-locale support (en_US, sv_SE, en_SE)

### Custom Packages (`pkgs.my.*`)

- `mpv-history-launcher` - Launch entries stored in text via `mpv-org-history`
- `mpv-skipsilence` - MPV plugin to skip silent portions
- `mpv-org-history` - Org-mode entries saved to file
- `chronotube` - YouTube video management tool
- `twitchindicator` - Twitch stream indicator
- `godot4-godotjs` - Godot 4 with JavaScript support
- `minecraft-modpack` - Custom Minecraft modpack
- And more...

## 🔧 Configuration Patterns

### Enable a Desktop Profile

```nix
# In hosts/nixos/<hostname>/profiles.nix
my.profiles = {
  plasma.enable = true;
  bluetooth.enable = true;
  fcitx5.enable = true;
};
```

### Configure Home Modules

```nix
# In hosts/homes/<user>@<host>/default.nix
my.home = {
  firefox.enable = true;
  mpv.enable = true;
  gaming.enable = true;
  command-line.enable = true;
};
```

### Use Custom Packages

```nix
# Available as pkgs.my.<name>
home.packages = with pkgs.my; [
  mpv-history-launcher
  chronotube
];
```

### Multi-Host Development

Set `HM_HOST_SLUG` environment variable (in `.env`) to build home-manager for any host:

```bash
export HM_HOST_SLUG=desktop
task test-home-manager  # Test jq@desktop from any machine
```

## 🔐 Secrets Management

Uses [sops-nix](https://github.com/Mic92/sops-nix) for encrypted secrets:

- Configuration in `.sops.yaml`
- Secrets stored in `secrets/` directory
- Age-based encryption with YubiKey support

For merge conflict handling, see: [sops merge conflicts](https://github.com/getsops/sops/issues/1117#issuecomment-1328336452)

## 🐋 Container Support

CI/CD builds containerized home environments for testing and distribution:

- Generic user environment in `user@container`
- GitHub Actions runner environment
- Automated builds via `.github/workflows/container.yml`

Credit to [kachick/dotfiles](https://github.com/kachick/dotfiles) for the containerized home images approach.

## 📦 Key Flake Inputs

- `nixpkgs` - NixOS unstable
- `home-manager` - User environment management
- `sops-nix` - Secrets management
- `nvf` - Neovim configuration framework
- `jovian` - Steam Deck support (Jovian-NixOS)
- `nix-minecraft` - Minecraft server management
- `alexandria` - Semantic code search MCP server
- `jqpkgs` - Personal package repository
- `disko` - Declarative disk partitioning
- Plus various custom service flakes (ccc, jellyfin-plugins, etc.)

## 🎯 Development Workflow

1. Make changes to modules or host configurations
2. Run `task test` to verify builds
3. Review changes with `nix flake check -L`
4. Pre-commit hooks run automatically (or `task pre-commit-all`)
5. Apply with `task nixos` and/or `task home-manager`

## 📚 Resources & Inspiration

### Documentation

- [NixOS Wiki - Platformio](https://wiki.nixos.org/wiki/Platformio)
- [Nixcademy - Debugging Overlays](https://nixcademy.com/posts/mastering-nixpkgs-overlays-techniques-and-best-practice/)
- [NixOS/nixpkgs - Python Overrides](https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md)
- [Useful Nix Hacks](http://www.chriswarbo.net/projects/nixos/useful_hacks.html)

### Inspirations

- [kachick/dotfiles](https://github.com/kachick/dotfiles) - Containerized home environments
- [Misterio77/nix-config](https://github.com/Misterio77/nix-config) - Modular architecture
- [TLATER/dotfiles](https://github.com/TLATER/dotfiles) - Sops secrets management
- [wimpysworld/nix-config](https://github.com/wimpysworld/nix-config) - Comprehensive examples
- [Faupi/nixos-configs](https://github.com/Faupi/nixos-configs) - Hardware configurations
- [ambroisie/nix-config](https://github.com/ambroisie/nix-config) - Clean structure

## 📝 License

This configuration is provided as-is for reference and inspiration. Feel free to adapt it for your own use.
