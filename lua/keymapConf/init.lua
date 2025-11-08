-- <nixCats>/lua/keymapConf/init.lua
-- Keybinds entry point following LazyVim conventions

-- Load general keymaps first (LazyVim core keymaps)
require("keymapConf.general")

-- Load functionality-specific keymaps
require("keymapConf.lsp")        -- LSP keymaps (replaces diagnostics + symbols)
require("keymapConf.git")        -- Git operations
require("keymapConf.search")     -- Search and find (replaces picker)
require("keymapConf.ui")         -- UI toggles and tools
require("keymapConf.buffers")    -- Buffer management (extracted from navigation)
require("keymapConf.debug")      -- Debug keymaps (if DAP enabled)

-- Load which-key group names following LazyVim conventions
local wk = require("which-key")
wk.add({
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code" },
  { "<leader>d", group = "debug" },
  { "<leader>f", group = "file/find" },
  { "<leader>g", group = "git" },
  { "<leader>gh", group = "hunks" },
  { "<leader>q", group = "quit/session" },
  { "<leader>s", group = "search" },
  { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
  { "<leader>w", group = "windows" },
  { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
  { "<leader><tab>", group = "tabs" },
  { "[", group = "prev" },
  { "]", group = "next" },
  { "g", group = "goto" },
  { "gs", group = "surround" },
  { "z", group = "fold" },
})
