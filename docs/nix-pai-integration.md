# Integrating nix-pai into NixOS Flake Configuration

This document describes the steps required to integrate `github:zmre/nix-pai` flakeModule into a NixOS flake-based configuration.

## Overview

The `nix-pai` flake provides a Personal AI Assistant (PAI) infrastructure using flake-parts' `perSystem` modules. To use it in a NixOS configuration, you need to:

1. Add required flake inputs
2. Import the flakeModule at the flake-parts level
3. Configure PAI settings in a perSystem module
4. Create a NixOS module to expose the PAI package
5. Enable PAI in your host configuration

## Required Changes

### 1. Add Flake Inputs

Add the following inputs to your `flake.nix`:

```nix
{
  inputs = {
    # ... your existing inputs ...

    # Required by nix-pai
    fabric = {
      url = "github:danielmiessler/fabric";
      flake = false;
    };
    nix-ai-tools.url = "github:numtide/llm-agents.nix";

    # Main PAI flake
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

**Note:** The `nix-pai` flake has dependencies on:

- `nix-ai-tools` - Provides claude-code and other AI development tools
- `fabric` - Provides AI prompt patterns
- `flake-parts` - Framework for composable flakes (you likely already have this)

### 2. Import the FlakeModule

Create a file `flake/pai.nix` (or similar) to import the nix-pai flakeModule:

```nix
{ self, inputs, ... }:
{
  imports = [
    inputs.nix-pai.flakeModules.default
  ];

  perSystem = { ... }: {
    # Pass flake inputs to perSystem modules
    _module.args.flakeInputs = inputs;

    imports = [
      "${self}/modules/pai"  # Your PAI configuration module
    ];
  };
}
```

Then import this in your main `flake/default.nix`:

```nix
flake-parts.lib.mkFlake { inherit inputs; } {
  systems = [ "x86_64-linux" "aarch64-linux" /* ... */ ];

  imports = [
    # ... your other imports ...
    ./pai.nix
  ];
}
```

### 3. Configure PAI Settings

Create `modules/pai/default.nix` to configure your PAI assistant:

```nix
# This is a flake module (perSystem)
{
  flakeInputs,
  pkgs,
  lib,
  ...
}:
{
  pai = {
    assistantName = "Iris";  # Name of your assistant
    commandName = "i";       # Command to invoke it

    extraPackages = with pkgs; [
      ripgrep
      tree
      fd
      # Add any other packages your assistant needs
    ];

    # Optional: Add extra skills
    extraSkills = [
      # Example: bundling multiple skill directories
      (let
        lndir = pkgs.lib.getExe pkgs.lndir;
      in
      with flakeInputs;
      pkgs.runCommandLocal "claude-code-skills" { } ''
        mkdir -p $out/{backend-skill,frontend-skill}
        ${lndir} "${AI-opencode-backend-skill.outPath}" "$out/backend-skill"
        ${lndir} "${AI-opencode-frontend-skill.outPath}" "$out/frontend-skill"
      '')
    ];

    # Override or extend Claude Code settings
    claudeSettings = {
      outputStyle = "explanatory";
      companyAnnouncements = [ "Welcome! I'm Iris, ready to help." ];
      assistantColor = "red";
      commandName = "i";

      permissions = {
        defaultMode = "default";
        allow = lib.mkAfter [
          "Bash(nix:*)"
        ];
      };

      # Enable Claude plugins
      enabledPlugins = {
        "typescript-lsp@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
        "pyright-lsp@claude-plugins-official" = true;
      };

      env = {
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        CLAUDE_CODE_MAX_OUTPUT_TOKENS = "64000";
        CLAUDE_CODE_ENABLE_TELEMETRY = "0";
        ENABLE_LSP_TOOL = "1";
      };
    };

    # Configure other tools
    otherTools = {
      enableCodex = false;
      enableGemini = false;
      enableOpencode = true;
    };

    opencodeSettings = {
      model = "ollama/qwen2.5-coder:latest";
      theme = "catppuccin";
    };

    # Configure MCP servers
    mcpServers = {
      # Example: Alexandria semantic code search
      alexandria = {
        type = "stdio";
        command = "alex";
        args = [ "serve" ];
      };
    };
  };
}
```

### 4. Create NixOS Module

Create `modules/nixos/programs/pai/default.nix` to expose the PAI package to NixOS:

```nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.programs.pai;
  # Access the PAI package from the flake's perSystem packages
  system = pkgs.stdenv.hostPlatform.system;
  paiPackage = inputs.self.packages.${system}.pai or null;
in
{
  options.my.programs.pai = with lib; {
    enable = mkEnableOption "Personal AI Assistant (PAI)";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = paiPackage != null;
        message = "PAI package not found for system ${system}. Make sure the pai flakeModule is properly configured.";
      }
    ];

    environment.systemPackages = lib.optional (paiPackage != null) paiPackage;
  };
}
```

**Note:** This example uses a custom `my.programs.*` namespace. Adjust to match your module system (e.g., `programs.pai.*` for standard NixOS modules).

### 5. Enable in Host Configuration

In your host configuration (e.g., `hosts/nixos/desktop/programs.nix`):

```nix
{
  my.programs = {
    pai.enable = true;
    # ... other programs ...
  };
}
```

## Testing

Build your NixOS configuration to verify everything works:

```bash
# Dry-run build
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel --dry-run

# Or use your taskfile
task test-nixos
```

The PAI command should be available in the system path after building:

```bash
# Check for the command
nix-store -q --references <result-path>/sw | grep -i pai

# Verify the command exists (using configured commandName)
ls <result-path>/sw/bin/i  # or whatever commandName you configured
```

## Key Considerations

### perSystem vs NixOS Modules

The `nix-pai` flakeModule operates at the `perSystem` level (flake-parts), not directly in NixOS modules. This means:

1. **Configuration happens in perSystem**: PAI settings are configured in a perSystem module
2. **Package exposure**: The PAI package is built per-system and exposed via `inputs.self.packages.${system}.pai`
3. **NixOS integration**: A NixOS module is needed to install the package system-wide or per-user

### Accessing Flake Inputs in perSystem

perSystem modules don't have direct access to `inputs`. You need to pass them explicitly:

```nix
perSystem = { ... }: {
  _module.args.flakeInputs = inputs;
  # Now perSystem modules can use `flakeInputs` parameter
};
```

### extraSkills Type

The `pai.extraSkills` option expects a **list of paths**, not a single path:

```nix
# ✅ Correct
extraSkills = [ /path/to/skills ];

# ❌ Incorrect
extraSkills = /path/to/skills;
```

## Upstream Improvements

For the `zmre/nix-pai` repository, consider documenting:

1. **Explicit input requirements**: Document that `nix-ai-tools` and `fabric` are required inputs
2. **NixOS integration example**: Provide an example NixOS module for system-wide installation
3. **perSystem context**: Clarify that this is a perSystem module and show how to pass inputs
4. **Type documentation**: Clarify that `extraSkills` is a list of paths
5. **Full integration example**: Provide a complete example flake showing all the pieces together

## Example Flake Structure

```
.
├── flake.nix                      # Main flake with inputs
├── flake/
│   ├── default.nix                # flake-parts composition
│   ├── pai.nix                    # PAI flakeModule import
│   ├── nixos.nix                  # NixOS configurations
│   └── ...
├── modules/
│   ├── pai/
│   │   └── default.nix            # perSystem PAI configuration
│   └── nixos/
│       └── programs/
│           └── pai/
│               └── default.nix    # NixOS module to install PAI
└── hosts/
    └── nixos/
        └── <hostname>/
            └── programs.nix       # Enable PAI for host
```

## Commands Available

After enabling PAI, the following commands will be available:

- `<commandName>` - Main PAI assistant (e.g., `i` for "Iris")
- `<commandName>-priv` - Private/local PAI using OpenCode
- `<commandName>-sandbox-yolo` - Sandboxed YOLO mode

All commands are wrappers around Claude Code with your configured settings.

## Resources

- nix-pai repository: https://github.com/zmre/nix-pai
- nix-ai-tools: https://github.com/numtide/llm-agents.nix
- Fabric patterns: https://github.com/danielmiessler/fabric
- flake-parts documentation: https://flake.parts/
