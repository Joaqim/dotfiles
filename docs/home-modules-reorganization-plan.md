# Home Modules Reorganization Plan

## Executive Summary

Reorganize the flat 48-module structure in `modules/home/` into logical categories that mirror the `modules/nixos/` structure. This improves navigation, maintainability, and scalability.

## Current Structure

```
modules/home/
├── atuin/
├── bluetooth/
├── ... (46 more flat modules)
└── default.nix (auto-imports all subdirectories)
```

Current auto-import in `modules/home/default.nix`:
```nix
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;
}
```

## Proposed Structure

### Categories

1. **development/** - Development tools & editors (9 modules)
2. **shell/** - Terminal & shell tools (10 modules)
3. **applications/** - GUI applications (5 modules)
4. **desktop/** - Desktop environment & theming (5 modules)
5. **media/** - Media players & tools (3 modules)
6. **utilities/** - System utilities & applets (6 modules)
7. **gaming/** - Gaming related (2 modules)
8. **services/** - User services (1 module)
9. **system/** - System config & core (6 modules)

### Full Module Categorization

```
modules/home/
├── applications/
│   ├── calibre/          # E-book manager
│   ├── discord/          # Chat
│   ├── firefox/          # Browser
│   ├── obs-studio/       # Streaming/recording
│   ├── qbittorrent/      # Torrent client
│   └── default.nix
│
├── desktop/
│   ├── gtk/              # GTK theming
│   ├── hyprland/         # Wayland compositor
│   ├── kde/              # KDE Plasma config
│   ├── themes/           # Theme configuration
│   ├── xdg/              # XDG directories
│   └── default.nix
│
├── development/
│   ├── cursor/           # Editor
│   ├── direnv/           # Environment management
│   ├── git/              # Version control
│   ├── nix/              # Nix development
│   ├── nix-index/        # Nix package search
│   ├── nixpkgs/          # Nixpkgs config
│   ├── nvf/              # Neovim
│   ├── opencode/         # VSCodium
│   ├── vscode/           # VS Code
│   └── default.nix
│
├── gaming/
│   ├── boilr/            # Game launcher integration
│   ├── gaming/           # Gaming tools bundle
│   └── default.nix
│
├── media/
│   ├── mpv/              # Video player
│   ├── yt-dlp/           # YouTube downloader
│   ├── zathura/          # PDF viewer
│   └── default.nix
│
├── services/
│   ├── vira/             # Web portal service
│   └── default.nix
│
├── shell/
│   ├── atuin/            # Shell history
│   ├── command-line/     # CLI utilities bundle
│   ├── dircolors/        # Directory colors
│   ├── fzf/              # Fuzzy finder
│   ├── nushell/          # Nushell shell
│   ├── pager/            # less/bat config
│   ├── starship/         # Shell prompt
│   ├── terminal/         # Terminal emulator config
│   ├── zellij/           # Terminal multiplexer
│   ├── zoxide/           # Smart directory jumper
│   └── default.nix
│
├── system/
│   ├── documentation/    # Man pages/docs
│   ├── gpg/              # GPG/encryption
│   ├── jq/               # JSON processor
│   ├── packages/         # General packages
│   ├── secrets/          # Secret management
│   ├── wget/             # Download tool
│   └── default.nix
│
├── utilities/
│   ├── bluetooth/        # Bluetooth applet
│   ├── bottom/           # System monitor
│   ├── flameshot/        # Screenshot tool
│   ├── nm-applet/        # Network manager applet
│   ├── power-alert/      # Power monitoring
│   ├── udiskie/          # Automount manager
│   └── default.nix
│
└── default.nix           # Root imports all categories
```

## Implementation Steps

### Step 1: Update Root default.nix

Replace `modules/home/default.nix` with category-aware imports:

```nix
{ lib, ... }:
# Import all category directories
# Each category has its own default.nix that imports its modules
let
  files = builtins.readDir ./.;
  # Filter for directories only, exclude default.nix
  categories = lib.filterAttrs (name: type:
    type == "directory"
  ) files;
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) categories;
  home.stateVersion = lib.mkForce "24.11";
}
```

### Step 2: Create Category default.nix Files

Each category directory needs a `default.nix` that imports its modules:

```nix
# Example: modules/home/development/default.nix
{ lib, ... }:
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;
}
```

This pattern repeats for all 9 categories.

### Step 3: Move Modules

Use `git mv` to preserve history:

```bash
# Create category directories
mkdir -p modules/home/{development,shell,applications,desktop,media,utilities,gaming,services,system}

# Move modules (example for development category)
git mv modules/home/cursor modules/home/development/
git mv modules/home/direnv modules/home/development/
git mv modules/home/git modules/home/development/
# ... etc
```

### Step 4: Test Each Category

After moving each category, test with:

```bash
task test-home-manager
# or
nix build .#homeConfigurations."jq@$(hostname)".activationPackage
```

### Step 5: Verify All Host Configurations

Test all home configurations:

```bash
nix build .#homeConfigurations."jq@desktop".activationPackage
nix build .#homeConfigurations."jq@qb".activationPackage
nix build .#homeConfigurations."deck@deck".activationPackage
# ... etc
```

## Migration Approach

### Option A: Gradual (Recommended)

1. Create all category directories and default.nix files
2. Update root default.nix to import categories
3. Move one category at a time
4. Test after each category
5. Commit after each successful category migration

**Benefits:**
- Less risk of breaking everything
- Easier to identify issues
- Can pause/resume migration
- Clearer git history

### Option B: All-at-Once

1. Create all category structures
2. Move all modules in one batch
3. Test everything together

**Benefits:**
- Faster completion
- Single commit for the change

**Risks:**
- Harder to debug if something breaks
- All-or-nothing approach

## Impact Analysis

### What Changes

1. **File paths** - Modules move from `modules/home/<module>` to `modules/home/<category>/<module>`
2. **Import structure** - Two-level import instead of one-level

### What Stays the Same

1. **Module options** - `my.home.firefox.enable` etc. remain unchanged
2. **Host configurations** - No changes needed in `hosts/homes/`
3. **Module content** - No changes to individual module files
4. **Functionality** - All modules work identically

### Breaking Changes

None for normal usage. Only affects:
- Direct path imports to specific modules (rare)
- External tooling that hardcodes paths
- Documentation referencing file paths

## Benefits

1. **Organization** - Related modules grouped logically
2. **Discoverability** - Easier to find relevant modules
3. **Consistency** - Mirrors nixos module structure
4. **Scalability** - Clear place for new modules
5. **Maintenance** - Easier to navigate large module count
6. **Documentation** - Natural hierarchy for docs

## Rollback Plan

If issues arise:

1. **Immediate rollback**: `git revert` the migration commit(s)
2. **Partial rollback**: Revert specific categories and test
3. **Full rebuild**: The old flat structure can be restored from git history

## Testing Checklist

- [ ] All category default.nix files created
- [ ] Root default.nix updated
- [ ] All modules moved to correct categories
- [ ] `nix flake check` passes
- [ ] `task test-home-manager` succeeds for current host
- [ ] All home configurations build successfully
- [ ] Sample activation test (dry-run) works
- [ ] Git history preserved (check with `git log --follow`)
- [ ] No orphaned files left in old locations
- [ ] Documentation updated

## Timeline Estimate

- **Gradual approach**: 2-3 hours
  - Setup: 30 min
  - Per category: 10-15 min × 9 categories
  - Final testing: 30 min

- **All-at-once**: 1-2 hours
  - Setup: 30 min
  - Migration: 30 min
  - Testing/debugging: 30-60 min

## Questions for Consideration

1. **Alternative categorizations?**
   - Could `terminal` be in `applications` instead of `shell`?
   - Should `nix-index` be in `system` instead of `development`?
   - Should there be a `productivity` category for calibre, etc.?

2. **Future categories?**
   - `cloud/` for cloud tools?
   - `security/` for security-focused tools?
   - `network/` for networking tools?

3. **Category naming?**
   - Plural vs singular (e.g., `applications` vs `application`)
   - Current choice: plural for consistency with nixos structure

## Next Steps

1. Review and approve this plan
2. Choose migration approach (gradual vs all-at-once)
3. Create git branch for migration
4. Execute migration
5. Test thoroughly
6. Merge to main
7. Update documentation

## References

- Current auto-import: `modules/home/default.nix`
- Home-manager integration: `flake/home-manager.nix`
- NixOS module structure: `modules/nixos/` (reference for categories)
- Host configurations: `hosts/homes/`