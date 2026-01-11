-- UI keymaps following LazyVim conventions
-- https://www.lazyvim.org/keymaps#ui

local map = vim.keymap.set

-- LazyVim UI toggles (using snacks when available)
if require("nixCatsUtils").enableForCategory("util") then
  local snacks = require("snacks")
  local snacks_keymap = require("lzextras").keymap("snacks.nvim")
  local snacks_toggle = snacks.toggle

  -- Standard LazyVim toggles
  snacks_toggle.option("spell"):map("<leader>us")
  snacks_toggle.option("wrap"):map("<leader>uw")
  snacks_toggle.option("relativenumber"):map("<leader>uL")
  snacks_toggle.diagnostics():map("<leader>ud")
  snacks_toggle.line_number():map("<leader>ul")
  snacks_toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
    :map("<leader>uc")
  snacks_toggle.treesitter():map("<leader>uT")
  snacks_toggle.option("background", { off = "light", on = "dark" }):map("<leader>ub")

  -- Inlay hints (if supported)
  if vim.lsp.inlay_hint then
    snacks_toggle.inlay_hints():map("<leader>uh")
  end

  -- Additional snacks-specific toggles
  snacks_toggle.animate():map("<leader>ua")
  snacks_toggle.scroll():map("<leader>uA")
  snacks_toggle.indent():map("<leader>ug")
  snacks_toggle.dim():map("<leader>uD")
  snacks_toggle.zen():map("<leader>uz")
  snacks_toggle.zoom():map("<leader>uZ")

  -- Colorscheme picker
  snacks_keymap.set("n", "<leader>uC", function()
    snacks.picker.colorschemes()
  end, { desc = "Colorscheme with Preview" })

  -- Notification history
  snacks_keymap.set("n", "<leader>un", function()
    snacks.notifier.show_history()
  end, { desc = "Notification History" })
  snacks_keymap.set("n", "<leader>uN", function()
    snacks.notifier.hide()
  end, { desc = "Dismiss All Notifications" })
else
  -- Manual toggles without snacks (already in general.lua)
end

-- File explorer (LazyVim style)
if require("nixCatsUtils").enableForCategory("util") then
  local snacks_keymap = require("lzextras").keymap("snacks.nvim")

  -- Neo-tree style keymaps for file explorer
  snacks_keymap.set("n", "<leader>e", function()
    require("snacks").explorer()
  end, { desc = "Explorer NeoTree (Root Dir)" })

  snacks_keymap.set("n", "<leader>E", function()
    require("snacks").explorer({ cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Explorer NeoTree (cwd)" })

  snacks_keymap.set("n", "<leader>fe", function()
    require("snacks").explorer()
  end, { desc = "Explorer NeoTree (Root Dir)" })

  snacks_keymap.set("n", "<leader>fE", function()
    require("snacks").explorer({ cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Explorer NeoTree (cwd)" })
end

-- Oil file manager (alternative explorer)
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

-- Mini.map (if available)
if require("nixCatsUtils").enableForCategory("editor") then
  local minimap_keymap = require("lzextras").keymap("mini.nvim")

  minimap_keymap.set("n", "<leader>um", function()
    require("mini.map").toggle()
  end, { desc = "Toggle Minimap" })

  minimap_keymap.set("n", "<leader>uM", function()
    require("mini.map").open()
    require("mini.map").toggle_focus()
  end, { desc = "Focus Minimap" })
end

-- Paq/Lazy/Mason (if not using Nix)
if not require("nixCatsUtils").isNixCats then
  map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
  map("n", "<leader>Cm", "<cmd>Mason<cr>", { desc = "Mason" })
  map("n", "<leader>Cp", "<cmd>PaqSync<cr>", { desc = "Paq Sync" })
end

-- Format toggle (global and buffer)
map("n", "<leader>uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify((vim.g.autoformat and "Enabled" or "Disabled") .. " autoformat", vim.log.levels.INFO)
end, { desc = "Toggle Auto Format (Global)" })

map("n", "<leader>uF", function()
  vim.b.autoformat = not vim.b.autoformat
  vim.notify((vim.b.autoformat and "Enabled" or "Disabled") .. " autoformat (buffer)", vim.log.levels.INFO)
end, { desc = "Toggle Auto Format (Buffer)" })
