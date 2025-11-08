# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NixCats is a Neovim configuration framework based on the nixCats-nvim template. It provides a reproducible, declarative Neovim setup using Nix flakes with fallback support for non-Nix environments via paq-nvim.

## Common Development Commands

### Testing and Development

```bash
# Enter development shell with full nixCats configuration
nix develop

# Enter minimal configuration shell (editor, formatting, treesitter, ui only)
nix develop .#none

# Build a specific package variant
nix build .#nixCats       # Full configuration with all features
nix build .#nixCats-none  # Minimal configuration

# Run nixCats directly from flake
nix run .#nixCats
```

### Building and Installing

```bash
# Build the default package
nix build

# Add to system configuration (NixOS)
# Add this flake as input and use the nixosModule

# Add to home-manager
# Add this flake as input and use the homeManagerModule

# Use as overlay in another flake
# Reference the overlays.default output
```

### Non-Nix Fallback

When Nix is not available, the configuration falls back to:
1. paq-nvim for plugin management (auto-bootstraps)
2. Mason.nvim for LSP installation
3. Plugins clone to `~/.local/share/nvim/site/pack/paqs/`

## Architecture and Structure

### Core Configuration Files

- **flake.nix**: Main orchestrator using nixCats.utils.baseBuilder
- **categoryDefinitions.nix**: Defines plugin categories and LSPs
  - Categories: `coding`, `debug`, `editor`, `formatting`, `lsp`, `markdown`, `treesitter`, `ui`, `util`
  - LSPs: clangd, lua-ls, nil, pyright, ruby-lsp, typescript-language-server
- **packageDefinitions.nix**: Package variants (nixCats full, nixCats-none minimal)
- **shell.nix**: Development shells for testing

### Lua Configuration Structure

Entry point: `init.lua` → `lua/luaConf/init.lua`

Key directories:
- **lua/luaConf/**: Core settings (options, colorscheme, LSP globals, autocmds)
- **lua/keymapConf/**: Organized keybindings by function (`<Leader>` prefixed)
- **lua/pluginConf/**: 80+ plugin configurations with lazy loading via lze
- **lua/nixCatsUtils/**: Nix integration and fallback utilities
- **ftplugin/**: Language-specific settings (indentation, tab stops)

### Category System

Plugins are organized into categories that can be enabled/disabled per package variant. Use these utilities:

```lua
-- Check if a category is enabled
require("nixCatsUtils").enableForCategory("lsp")

-- Conditionally add plugin for category
require("nixCatsUtils").lazyAdd("plugin-name", pluginSpec, "category-name")
```

### Plugin Loading

Uses `lze` (lazy loading engine) with custom handlers:
- `for_cat`: Load plugin only if category is enabled
- `in_extra`: Load plugin based on extra configuration

## Key Keybindings

- **Leader**: Space
- **Function Keys**: Language-specific actions (F1=Help, F2=Rename, F5=Debug, F7=Build, etc.)
- **Global Commands**: `<Leader>` + category (d=diagnostics, g=git, n=navigation, etc.)

## LSP and Formatting

LSPs are provided via Nix when available, falling back to Mason.nvim. Configure in:
- LSP setup: `lua/pluginConf/lsp.lua`
- Formatting: `lua/pluginConf/conform.lua`
- Linting: `lua/pluginConf/nvim-lint.lua`

## Testing Changes

1. Modify configuration files
2. Test with `nix develop` (full) or `nix develop .#none` (minimal)
3. Changes to Nix files require rebuild, Lua changes reload immediately
4. Use `:checkhealth` to verify plugin/LSP status

## Adding New Plugins

1. Add to `categoryDefinitions.nix` under appropriate category
2. Create config in `lua/pluginConf/` with lze spec
3. Use `require("nixCatsUtils").lazyAdd()` for conditional loading
4. Test both with Nix and fallback (paq-nvim) modes

## Package Variants

- **nixCats**: Full configuration with all categories, Neovim nightly
- **nixCats-none**: Minimal (editor, formatting, treesitter, ui only), no LSPs

Both include Python 3 and Node.js host support, Catppuccin Mocha theme.