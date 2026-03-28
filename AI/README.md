# Claude Code Custom Skills

This directory contains custom skills that extend Claude Code's capabilities for working with this NixOS configuration repository.

## Available Skills

### nixos-test-changes
**Incremental NixOS/home-manager testing** - Test only what changed for 6-7x faster feedback.

- **Trigger**: "test my changes", "quick test", "incremental test", "check what changed"
- **Performance**: ~9s vs ~60s for single host changes
- **Usage**: `task inc` for quick testing, `task test-changes` to analyze
- **See**: `skills/nixos-test-changes/SKILL.md`

### nvf-debugging-skill
**NVF configuration debugging** - Trace Nix module configurations through to runtime Neovim state.

- **Trigger**: "debug nvf", "neovim config not working", "setupOpts not applying"
- **Capability**: Full debugging chain from Nix declaration to Lua to runtime
- **See**: `skills/nvf-debugging-skill/SKILL.md`

## Using Skills

Skills are automatically loaded by Claude Code when relevant. You can:

```bash
# Directly request capabilities in conversation
"test my nixos changes"
"debug my neovim configuration"
"check what changed in my configuration"

# Or use the underlying tools directly
task inc                    # Incremental test
task test-changes          # Analyze changes
```

## Creating New Skills

To create a new skill, use the `claude:create-skill` skill or manually follow the pattern:

## Skill Structure

```
skills/
├── README.md                    # This file
└── skill-name/
    ├── SKILL.md                # Required: Main skill definition with frontmatter
    ├── README.md               # Optional: Human-readable documentation
    └── workflows/              # Optional: Detailed workflow guides
```

### Required Frontmatter

Each `SKILL.md` must include frontmatter:

```markdown
---
name: skill-name
description: Brief description. USE WHEN user says 'trigger phrase' or needs this capability.
---
```

## Integration with Claude Code

Skills in this directory are automatically discovered and loaded by Claude Code. They complement the built-in system skills available in the Claude Code installation.
