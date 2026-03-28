# GitHub Issue: Improve Documentation for NixOS Integration

**Title**: Document required inputs and provide NixOS system-wide installation example

## Summary

The current documentation doesn't explicitly document required flake inputs (`nix-ai-tools`, `fabric`) or provide guidance for installing PAI system-wide on NixOS. This leads to integration challenges for new users.

## Issues

1. **Missing input documentation**: The README doesn't state that `nix-ai-tools` and `fabric` are required dependencies
2. **No NixOS integration example**: Documentation only shows perSystem usage, not system-wide installation
3. **perSystem context unclear**: Users may not realize this is a flake-parts perSystem module
4. **Type confusion**: `extraSkills` type (list vs single path) not documented

## Errors Encountered During Integration

```
error: attribute 'nix-ai-tools' missing
error: attribute 'fabric' missing
error: 'inputs' is not a perSystem module argument
error: definition is not of type 'list of absolute path'
```

## Proposed Solutions

### 1. Document Required Inputs

Add to README.md:

```markdown
## Required Flake Inputs

```nix
{
  inputs = {
    fabric = {
      url = "github:danielmiessler/fabric";
      flake = false;
    };
    nix-ai-tools.url = "github:numtide/llm-agents.nix";

    nix-pai = {
      url = "github:zmre/nix-pai";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-ai-tools.follows = "nix-ai-tools";
      inputs.flake-parts.follows = "flake-parts";
      inputs.fabric.follows = "fabric";
    };
  };
}
```
```

### 2. Add NixOS Integration Guide

Create `docs/NIXOS.md` with complete integration example:

<details>
<summary>Complete NixOS Integration Example</summary>

**flake.nix**:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    fabric = {
      url = "github:danielmiessler/fabric";
      flake = false;
    };
    nix-ai-tools.url = "github:numtide/llm-agents.nix";
    nix-pai = {
      url = "github:zmre/nix-pai";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-ai-tools.follows = "nix-ai-tools";
      inputs.flake-parts.follows = "flake-parts";
      inputs.fabric.follows = "fabric";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.nix-pai.flakeModules.default
      ];

      perSystem = { ... }: {
        _module.args.flakeInputs = inputs;

        imports = [ ./modules/pai ];
      };

      flake.nixosConfigurations.myhost = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./modules/nixos/programs/pai
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
```

**modules/pai/default.nix** (perSystem configuration):
```nix
{ pkgs, ... }:
{
  pai = {
    assistantName = "Iris";
    commandName = "i";
    extraPackages = with pkgs; [ ripgrep tree fd ];
  };
}
```

**modules/nixos/programs/pai/default.nix** (NixOS module):
```nix
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.programs.pai;
  system = pkgs.stdenv.hostPlatform.system;
  paiPackage = inputs.self.packages.${system}.pai or null;
in
{
  options.programs.pai.enable = lib.mkEnableOption "PAI";

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = paiPackage != null;
      message = "PAI package not found for ${system}";
    }];
    environment.systemPackages = [ paiPackage ];
  };
}
```

**configuration.nix**:
```nix
{
  programs.pai.enable = true;
}
```

</details>

### 3. Add Troubleshooting Section

```markdown
## Troubleshooting

**Error: `attribute 'nix-ai-tools' missing`**
- Add `nix-ai-tools` to your flake inputs (see Required Flake Inputs)

**Error: `'inputs' is not a perSystem module argument`**
- Pass inputs via `_module.args`: `perSystem = { ... }: { _module.args.flakeInputs = inputs; };`

**Error: `definition is not of type 'list of absolute path'`**
- `extraSkills` expects a list: `extraSkills = [ ./path ];` not `extraSkills = ./path;`
```

### 4. Document Option Types

```markdown
## Configuration Options

### `pai.extraSkills`
- **Type**: `listOf path`
- **Example**: `extraSkills = [ ./my-skills ];`

### `pai.extraPackages`
- **Type**: `listOf package`
- **Example**: `extraPackages = with pkgs; [ ripgrep fd ];`
```

## Benefits

- **Prevents common errors**: Explicit input requirements prevent cryptic error messages
- **Supports primary use case**: Most users want system-wide installation
- **Reduces integration time**: Complete examples that work copy-paste
- **Better discoverability**: Clear architecture explanation helps users understand the design

## Implementation Checklist

- [ ] Add "Required Flake Inputs" section to README
- [ ] Create `docs/NIXOS.md` with complete integration example
- [ ] Add troubleshooting section
- [ ] Document option types clearly
- [ ] Add example in `examples/nixos-flake/`
- [ ] Update quickstart to mention NixOS integration

## Additional Context

This issue is based on real integration experience adding nix-pai to a production NixOS flake configuration. All errors and solutions are tested and working.

## Related

- flake-parts documentation: https://flake.parts/
- Integration blog post: [if you write one]
- Working example: [link to your dotfiles if you want to share]

---

**Would you like me to submit a PR with these documentation improvements?**
