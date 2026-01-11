-- LSP keymaps following LazyVim conventions
-- https://www.lazyvim.org/keymaps#lsp

local map = vim.keymap.set

-- LSP navigation keymaps (always available)
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References", nowait = true })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto T[y]pe Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- Code actions and refactoring
map({ "n", "v" }, "<leader>Ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map({ "n", "v" }, "<leader>Cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
map("n", "<leader>CC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
map("n", "<leader>Cr", vim.lsp.buf.rename, { desc = "Rename" })

-- If using inc-rename plugin
if require("nixCatsUtils").enableForCategory("editor") then
  map("n", "<leader>Cr", function()
    local inc_rename = require("inc_rename")
    return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
  end, { expr = true, desc = "Rename (inc-rename)" })
end

-- Source action
map("n", "<leader>CA", function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source" },
      diagnostics = {},
    },
  })
end, { desc = "Source Action" })

-- LSP info
map("n", "<leader>Cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })

-- If using snacks picker for enhanced LSP navigation
if require("nixCatsUtils").enableForCategory("util") then
  local snacks = require("snacks")

  -- Override with snacks picker versions
  map("n", "gd", function()
    snacks.picker.lsp_definitions()
  end, { desc = "Goto Definition" })
  map("n", "gr", function()
    snacks.picker.lsp_references()
  end, { desc = "References" })
  map("n", "gI", function()
    snacks.picker.lsp_implementations()
  end, { desc = "Goto Implementation" })
  map("n", "gy", function()
    snacks.picker.lsp_type_definitions()
  end, { desc = "Goto T[y]pe Definition" })

  -- Additional snacks LSP pickers
  map("n", "<leader>Cs", function()
    snacks.picker.lsp_symbols()
  end, { desc = "LSP Symbols" })
  map("n", "<leader>CS", function()
    snacks.picker.lsp_workspace_symbols()
  end, { desc = "LSP Workspace Symbols" })
end

-- If using trouble for enhanced diagnostics
if require("nixCatsUtils").enableForCategory("editor") then
  -- Trouble-specific keymaps
  map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
  map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
  map("n", "<leader>Cs", "<cmd>AerialToggle<cr>", { desc = "Symbols (Aerial)" })
  map({ "n", "t" }, "<C-s>s", "<cmd>AerialToggle<cr>", { desc = "Symbols (Aerial)" })
  map(
    "n",
    "<leader>Cl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    { desc = "LSP Definitions / references / ... (Trouble)" }
  )
  map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
  map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
end
