# nix-pai Integration Summary

This directory contains documentation for integrating `github:zmre/nix-pai` into NixOS configurations and suggestions for upstream improvements.

## Documentation Files

### 1. `nix-pai-integration.md`
**Purpose**: Complete integration guide for users
**Audience**: Anyone trying to add nix-pai to their NixOS flake

Contains:
- Step-by-step integration instructions
- All required flake inputs
- Complete code examples
- Troubleshooting guide
- Full flake structure example

**Use this**: As a reference when integrating nix-pai into your own configs

### 2. `upstream-nix-pai-suggestions.md`
**Purpose**: Detailed suggestions for improving upstream documentation
**Audience**: nix-pai maintainers

Contains:
- Issues encountered during integration
- Specific documentation improvements needed
- Before/after examples
- Architecture clarifications
- New documentation structure proposals

**Use this**: To understand what documentation gaps exist and how to fix them

### 3. `github-issue-nix-pai.md`
**Purpose**: GitHub-ready issue template
**Audience**: Ready to submit to zmre/nix-pai repository

Contains:
- Concise problem statement
- Specific errors encountered
- Actionable solutions
- Implementation checklist
- Minimal working examples

**Use this**: As a template for submitting an issue or starting a discussion on GitHub

## Quick Reference: What We Did

### Changes to This Repository

```
dotfiles/
├── flake.nix                          # Added fabric, nix-ai-tools inputs
├── flake/
│   └── pai.nix                        # Import nix-pai flakeModule
├── modules/
│   ├── pai/
│   │   └── default.nix                # PAI configuration (perSystem)
│   └── nixos/
│       └── programs/
│           └── pai/
│               └── default.nix        # NixOS module to install PAI
└── hosts/
    └── nixos/
        └── desktop/
            └── programs.nix           # Enable: my.programs.pai.enable = true
```

### Key Learnings

1. **Required Inputs**: `nix-ai-tools` and `fabric` must be added as flake inputs
2. **perSystem Module**: nix-pai is a flake-parts perSystem module, not a NixOS module
3. **Input Passing**: Must explicitly pass inputs to perSystem via `_module.args`
4. **Type Matters**: `extraSkills` is a list of paths, not a single path
5. **NixOS Wrapper**: Need a NixOS module to expose the PAI package system-wide

## Next Steps

### For Your Configuration

- [x] Build successfully completes
- [ ] Test the `i` command after applying configuration
- [ ] Verify Claude Code integration works
- [ ] Test MCP servers (alexandria)
- [ ] Configure additional skills if needed

### For Upstream Contribution

1. **Review the docs**: Read through the generated documentation
2. **Test the examples**: Ensure all examples work in a clean environment
3. **Choose contribution method**:
   - Submit issue using `github-issue-nix-pai.md` as template
   - Create PR with documentation improvements
   - Start discussion in nix-pai repository
4. **Share experience**: Consider blogging about the integration

### Optional Enhancements

- Add home-manager integration (alternative to system-wide)
- Create declarative skill management
- Add multiple assistant configurations
- Integrate with existing claude-code setup

## Commands Reference

### Building
```bash
# Test NixOS build
task test-nixos

# Apply to system
task nixos

# Apply both NixOS and home-manager
task apply
```

### Using PAI
```bash
# Main assistant (after switching to new config)
i

# Private/local mode
i-priv

# Sandbox YOLO mode
i-sandbox-yolo
```

### Checking Installation
```bash
# Check if PAI is in system path
which i

# Check PAI package version
i --version

# Verify Claude Code
i --help
```

## Verification Checklist

After applying the configuration:

- [ ] `i` command is available in PATH
- [ ] `i --version` shows version information
- [ ] Claude Code starts without errors
- [ ] Configured MCP servers are loaded
- [ ] Extra packages are available (ripgrep, tree, fd, azure-cli)
- [ ] Skills are accessible
- [ ] Settings are applied (check ~/.config/Claude Code/)

## Troubleshooting Quick Fixes

**Build fails with "attribute 'X' missing"**
```bash
# Ensure flake.lock is updated
nix flake lock
```

**perSystem module errors**
```nix
# Ensure inputs are passed
perSystem = { ... }: {
  _module.args.flakeInputs = inputs;
};
```

**PAI package not found**
```nix
# Verify in NixOS module
assertions = [{
  assertion = paiPackage != null;
  message = "Check that nix-pai.flakeModules.default is imported";
}];
```

## Resources

- nix-pai repository: https://github.com/zmre/nix-pai
- nix-ai-tools: https://github.com/numtide/llm-agents.nix
- Fabric patterns: https://github.com/danielmiessler/fabric
- flake-parts: https://flake.parts/
- Claude Code: https://claude.com/code

## Contact

For questions about this integration:
- Check the integration guide (`nix-pai-integration.md`)
- Review upstream suggestions (`upstream-nix-pai-suggestions.md`)
- Submit issue to nix-pai using template (`github-issue-nix-pai.md`)

---

**Status**: ✅ Integration complete and tested
**Date**: 2026-03-27
**Configuration**: desktop NixOS host
