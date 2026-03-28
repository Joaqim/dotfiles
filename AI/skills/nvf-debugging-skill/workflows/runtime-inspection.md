# Advanced Runtime Inspection Techniques

How to deeply inspect NeoVim's runtime state to understand what's actually loaded and configured.

## Basic Runtime Inspection

### Headless Execution

Run NeoVim in headless mode to inspect state without opening the editor.

```bash
# Basic pattern
nvim --headless +"lua <your-code>" +qa

# With error output
nvim --headless +"lua <your-code>" +qa 2>&1

# Filter warnings
nvim --headless +"lua <your-code>" +qa 2>&1 | grep -v "deprecated\|stopped"
```

### Inspecting Plugin Modules

```bash
# See entire plugin module
nvim --headless +"lua print(vim.inspect(require('plugin')))" +qa 2>&1

# Check if plugin loaded
nvim --headless +"lua local ok, plugin = pcall(require, 'plugin'); print('loaded:', ok)" +qa 2>&1

# Get plugin version
nvim --headless +"lua print(require('plugin').version or 'no version')" +qa 2>&1
```

## Common Plugin Config Locations

Different plugins store configuration in different places.

### Pattern 1: .config

```bash
nvim --headless +"lua print(vim.inspect(require('plugin').config))" +qa 2>&1
```

### Pattern 2: .state.config

```bash
nvim --headless +"lua print(vim.inspect(require('plugin').state.config))" +qa 2>&1
```

### Pattern 3: .opts or .options

```bash
nvim --headless +"lua print(vim.inspect(require('plugin').opts))" +qa 2>&1
```

### Pattern 4: Module-level variables

```bash
nvim --headless +"lua local M = require('plugin'); for k,v in pairs(M) do if type(v) ~= 'function' then print(k, vim.inspect(v)) end end" +qa 2>&1
```

## Timing Issues - Late Loading Plugins

Some plugins lazy-load or initialize after a delay.

### Using defer_fn for Delayed Inspection

```bash
# Wait 100ms before inspecting
nvim --headless +"lua vim.defer_fn(function() print(vim.inspect(require('plugin').config)); vim.cmd('qa!') end, 100)" 2>&1

# Wait longer for slow-loading plugins
nvim --headless +"lua vim.defer_fn(function() print(vim.inspect(require('plugin'))); vim.cmd('qa!') end, 500)" 2>&1
```

### Check if Plugin is Lazy-Loaded

```bash
# Check lazy.nvim configuration
nvim --headless +"lua print(vim.inspect(require('lazy.core.config').plugins))" +qa 2>&1 | grep "your-plugin" -A 5
```

## Inspecting Specific Configuration Values

### Single Value Inspection

```bash
# Check one specific option
nvim --headless +"lua local cfg = require('plugin').state.config; print('option:', cfg.option_name)" +qa 2>&1

# With nil check
nvim --headless +"lua local cfg = require('plugin').state.config; print('option:', cfg.option_name or 'NOT SET')" +qa 2>&1

# Deep nested value
nvim --headless +"lua local cfg = require('plugin').state.config; print('nested:', cfg.server and cfg.server.port or 'NOT SET')" +qa 2>&1
```

### Multiple Values

```bash
nvim --headless +"lua local cfg = require('plugin').state.config; print('command:', cfg.command, 'auto_start:', cfg.auto_start, 'port:', cfg.server.port)" +qa 2>&1
```

## Inspecting Keymaps

Check if plugin keymaps are registered.

```bash
# All keymaps for mode
nvim --headless +"lua print(vim.inspect(vim.api.nvim_get_keymap('n')))" +qa 2>&1 | grep "plugin-name"

# Specific keymap
nvim --headless +"lua local maps = vim.api.nvim_get_keymap('n'); for _, map in ipairs(maps) do if map.lhs == '<leader>ac' then print(vim.inspect(map)) end end" +qa 2>&1
```

## Inspecting Commands

Check if plugin commands are registered.

```bash
# Check if command exists
nvim --headless +"lua print('exists:', vim.fn.exists(':ClaudeCode'))" +qa 2>&1

# List all commands matching pattern
nvim --headless +"lua print(vim.inspect(vim.api.nvim_get_commands({})['ClaudeCode']))" +qa 2>&1
```

## Inspecting Autocommands

```bash
# Check plugin autocommands
nvim --headless +"lua print(vim.inspect(vim.api.nvim_get_autocmds({ group = 'PluginName' })))" +qa 2>&1
```

## Interactive Runtime Debugging

For complex inspection, enter an interactive session.

### Method 1: Use nvim Directly

```bash
# Open nvim and run Lua command
nvim +"lua print(vim.inspect(require('plugin').state.config))"

# Then inspect interactively
:lua print(vim.inspect(require('plugin')))
:lua =require('plugin').version
```

### Method 2: Use a Test File

```bash
# Create test file
cat > /tmp/nvim-debug.lua <<'EOF'
local plugin = require('plugin')
print('Plugin loaded:', plugin ~= nil)
print('Config:', vim.inspect(plugin.state.config))
print('Command value:', plugin.state.config.command)
EOF

# Source and run
nvim --headless -S /tmp/nvim-debug.lua +qa 2>&1
```

## Comparing Expected vs Actual

Create a script to compare what you expect vs reality.

```bash
cat > /tmp/verify-config.lua <<'EOF'
local plugin = require('your-plugin')
local cfg = plugin.state.config

local expected = {
  command = "i",
  auto_start = true,
  server = { host = "localhost", port = 9000 }
}

local function compare(path, expected_val, actual_val)
  if expected_val ~= actual_val then
    print(string.format("MISMATCH %s: expected %s, got %s",
      path, vim.inspect(expected_val), vim.inspect(actual_val)))
  else
    print(string.format("OK %s: %s", path, vim.inspect(actual_val)))
  end
end

compare("command", expected.command, cfg.command)
compare("auto_start", expected.auto_start, cfg.auto_start)
compare("server.host", expected.server.host, cfg.server.host)
compare("server.port", expected.server.port, cfg.server.port)
EOF

nvim --headless -S /tmp/verify-config.lua +qa 2>&1 | grep -v "deprecated"
```

## Checking Package/Plugin Paths

```bash
# Where is the plugin installed?
nvim --headless +"lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))" +qa 2>&1 | grep "plugin-name"

# Check if plugin file exists
nvim --headless +"lua print(vim.fn.globpath(vim.o.runtimepath, 'lua/plugin-name/init.lua'))" +qa 2>&1
```

## Environment Variables

```bash
# Check if plugin sees environment variables
nvim --headless +"lua print('VAR:', vim.env.MY_VAR or 'NOT SET')" +qa 2>&1

# Check PATH
nvim --headless +"lua print(vim.env.PATH)" +qa 2>&1
```

## Logging Plugin Behavior

Some plugins have debug logging.

```bash
# Enable debug mode (plugin-specific)
nvim --headless +"lua vim.g.plugin_debug = 1; require('plugin').setup({...}); vim.cmd('qa!')" 2>&1

# Check plugin logs
cat ~/.local/state/nvim/plugin-name.log

# Or XDG paths
cat ~/.local/state/nvf/plugin-name.log
```

## Saving Inspection Output

```bash
# Save full inspection to file
nvim --headless +"lua print(vim.inspect(require('plugin')))" +qa 2>&1 > /tmp/plugin-state.lua

# Then review with syntax highlighting
nvim /tmp/plugin-state.lua
```

## Common Inspection Script

Save this for quick debugging:

```bash
cat > ~/bin/nvim-inspect <<'EOF'
#!/usr/bin/env bash
# Usage: nvim-inspect plugin-name [config-path]
# Example: nvim-inspect claudecode state.config

PLUGIN=$1
CONFIG_PATH=${2:-"config"}

nvim --headless +"lua \
  local ok, plugin = pcall(require, '$PLUGIN'); \
  if not ok then \
    print('ERROR: Plugin $PLUGIN not found'); \
  else \
    local val = plugin; \
    for part in string.gmatch('$CONFIG_PATH', '[^.]+') do \
      val = val[part]; \
      if not val then break end; \
    end; \
    print(vim.inspect(val or 'NOT FOUND')); \
  end" +qa 2>&1 | grep -v "deprecated\|stopped"
EOF

chmod +x ~/bin/nvim-inspect

# Use it
nvim-inspect claudecode state.config
nvim-inspect lspconfig
```

## Troubleshooting Runtime Inspection

### Error: "module not found"

Plugin might not be in runtimepath.

```bash
# Check runtimepath
nvim --headless +"lua for path in string.gmatch(vim.o.runtimepath, '[^,]+') do print(path) end" +qa 2>&1 | grep plugin
```

### Error: "nil value"

Config hasn't been set or is in different location.

```bash
# Find where config actually is
nvim --headless +"lua local M = require('plugin'); for k,v in pairs(M) do print(k, type(v)) end" +qa 2>&1
```

### Lua Execution Timeout

Use simpler queries or increase timeout.

```bash
# Simpler query
nvim --headless +"lua print(require('plugin').state.config.command)" +qa 2>&1

# Or use defer_fn with longer delay
nvim --headless +"lua vim.defer_fn(function() print(...); vim.cmd('qa!') end, 1000)" 2>&1
```
