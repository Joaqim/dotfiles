# Suggested Documentation Improvements for zmre/nix-pai

This document outlines suggested improvements to the `nix-pai` documentation based on integrating it into a NixOS flake configuration.

## Issues Encountered

1. **Missing input documentation**: The README doesn't explicitly state that `nix-ai-tools` and `fabric` are required inputs
2. **No NixOS integration example**: Only shows perSystem usage, not how to install system-wide on NixOS
3. **perSystem context not clear**: Users may not realize this is a flake-parts perSystem module
4. **Input passing not documented**: No example of how to pass flake inputs to perSystem modules
5. **Type confusion**: `extraSkills` type (list of paths) not clearly documented

## Proposed Documentation Additions

### 1. Clear Input Requirements Section

Add to README.md:

```markdown
## Flake Inputs

To use nix-pai, you must add the following inputs to your flake:

```nix
{
  inputs = {
    # Required by nix-pai
    fabric = {
      url = "github:danielmiessler/fabric";
      flake = false;
    };
    nix-ai-tools.url = "github:numtide/llm-agents.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # PAI itself
    nix-pai = {
      url = "github:zmre/nix-pai";
      # Recommended: follow your nixpkgs for consistency
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-ai-tools.follows = "nix-ai-tools";
      inputs.flake-parts.follows = "flake-parts";
      inputs.fabric.follows = "fabric";
    };
  };
}
```

**Why these inputs?**
- `nix-ai-tools`: Provides Claude Code and AI development tooling
- `fabric`: Provides AI prompt patterns and tools
- `flake-parts`: Required framework (you likely already have this)
```

### 2. Add NixOS System-Wide Installation Example

Add a new section:

```markdown
## Using PAI System-Wide on NixOS

The nix-pai flakeModule operates at the `perSystem` level. To install PAI system-wide on NixOS:

**Step 1: Import the flakeModule**

```nix
# flake/pai.nix
{ self, inputs, ... }:
{
  imports = [
    inputs.nix-pai.flakeModules.default
  ];

  perSystem = { ... }: {
    # Pass flake inputs to perSystem modules
    _module.args.flakeInputs = inputs;

    imports = [
      "${self}/modules/pai"  # Your configuration
    ];
  };
}
```

**Step 2: Configure PAI settings**

```nix
# modules/pai/default.nix
{ flakeInputs, pkgs, lib, ... }:
{
  pai = {
    assistantName = "Iris";
    commandName = "i";
    extraPackages = with pkgs; [ ripgrep tree fd ];
    # ... other settings ...
  };
}
```

**Step 3: Create a NixOS module to install the package**

```nix
# modules/nixos/programs/pai/default.nix
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.programs.pai;
  system = pkgs.stdenv.hostPlatform.system;
  paiPackage = inputs.self.packages.${system}.pai or null;
in
{
  options.programs.pai = {
    enable = lib.mkEnableOption "Personal AI Assistant (PAI)";
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = paiPackage != null;
      message = "PAI package not found for ${system}";
    }];
    environment.systemPackages = [ paiPackage ];
  };
}
```

**Step 4: Enable in your NixOS configuration**

```nix
# hosts/nixos/hostname/configuration.nix
{
  programs.pai.enable = true;
}
```
```

### 3. Add perSystem Context Explanation

Add to the architecture/design section:

```markdown
## Architecture

nix-pai is built as a flake-parts `perSystem` module. This means:

1. **Configuration is per-system**: Settings are configured at the `perSystem` level
2. **Package outputs**: Builds `packages.${system}.pai` for each supported system
3. **Not a direct NixOS module**: Requires a wrapper NixOS module for system installation
4. **Requires flake-parts**: Must be used in a flake-parts-based flake

### Accessing Flake Inputs

perSystem modules don't automatically receive the `inputs` parameter. Pass them explicitly:

```nix
perSystem = { ... }: {
  _module.args.flakeInputs = inputs;  # or any name you prefer
  # Now your modules can use `flakeInputs` parameter
};
```
```

### 4. Document Option Types

Add to options documentation:

```markdown
## Configuration Options

### `pai.extraSkills`

- **Type**: `listOf path`
- **Default**: `[]`
- **Example**:
  ```nix
  extraSkills = [
    ./my-skills
    (pkgs.fetchFromGitHub {
      owner = "user";
      repo = "skills";
      rev = "...";
      hash = "...";
    })
  ];
  ```

**Note**: This is a **list** of paths, not a single path. Each path should point to a directory containing skill definitions.

### `pai.extraPackages`

- **Type**: `listOf package`
- **Default**: `[]`
- **Example**: `extraPackages = with pkgs; [ ripgrep fd tree ];`

Additional packages to include in the PAI environment.
```

### 5. Add Complete Integration Example

Create a new file `examples/nixos-flake/` with a complete working example:

```
examples/
└── nixos-flake/
    ├── flake.nix              # Complete flake with all inputs
    ├── flake/
    │   ├── default.nix        # flake-parts composition
    │   └── pai.nix            # PAI module import
    ├── modules/
    │   ├── pai/
    │   │   └── default.nix    # PAI configuration
    │   └── nixos/
    │       └── programs/
    │           └── pai/
    │               └── default.nix  # NixOS module
    └── configuration.nix      # Minimal NixOS config using PAI
```

### 6. Add Troubleshooting Section

```markdown
## Troubleshooting

### "attribute 'nix-ai-tools' missing"

**Cause**: Missing required flake input
**Solution**: Add `nix-ai-tools` to your flake inputs (see [Flake Inputs](#flake-inputs))

### "attribute 'fabric' missing"

**Cause**: Missing required flake input
**Solution**: Add `fabric` to your flake inputs (see [Flake Inputs](#flake-inputs))

### "'inputs' is not a perSystem module argument"

**Cause**: Trying to use `inputs` directly in a perSystem module
**Solution**: Pass inputs explicitly via `_module.args`:
```nix
perSystem = { ... }: {
  _module.args.flakeInputs = inputs;
};
```

### "definition is not of type 'list of absolute path'" for extraSkills

**Cause**: `extraSkills` is set to a single path instead of a list
**Solution**: Wrap your path in a list:
```nix
# Wrong
extraSkills = ./my-skills;

# Correct
extraSkills = [ ./my-skills ];
```

### PAI package not found for system

**Cause**: The PAI package wasn't built for your system
**Solution**:
1. Ensure `nix-pai.flakeModules.default` is imported
2. Verify your system is in the supported systems list
3. Check that perSystem configuration is loaded
```

## Summary of Changes Needed

### README.md
- [ ] Add explicit "Flake Inputs" section
- [ ] Add "Using PAI System-Wide on NixOS" section
- [ ] Clarify perSystem module context
- [ ] Document option types more clearly
- [ ] Add troubleshooting section

### New Files
- [ ] `examples/nixos-flake/` - Complete working example
- [ ] `ARCHITECTURE.md` - Detailed architecture explanation
- [ ] `NIXOS.md` - NixOS-specific integration guide

### Existing Documentation
- [ ] Update quickstart to mention required inputs
- [ ] Add note about perSystem vs NixOS modules
- [ ] Clarify that wrapper module is needed for NixOS

## Benefits

These changes would:

1. **Reduce integration friction**: Clear input requirements prevent "attribute missing" errors
2. **Support common use case**: Most users want system-wide installation
3. **Improve discoverability**: Examples show the complete integration pattern
4. **Prevent common mistakes**: Type documentation and troubleshooting prevent errors
5. **Better architecture understanding**: Clear explanation of flake-parts perSystem pattern

## Testing the Documentation

Create a test repository that follows the documentation exactly to ensure:
- All required inputs are documented
- Copy-paste examples work without modification
- Troubleshooting covers actual errors encountered
- NixOS integration example builds successfully
