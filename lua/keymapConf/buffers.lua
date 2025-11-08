-- Buffer management keymaps following LazyVim conventions
-- https://www.lazyvim.org/keymaps#buffers

local map = vim.keymap.set

-- Buffer navigation (these are also in general.lua but grouped here for clarity)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Buffer management
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Buffer deletion (using snacks if available)
if require("nixCatsUtils").enableForCategory("util") then
  local snacks = require("snacks")

  map("n", "<leader>bd", function() snacks.bufdelete() end, { desc = "Delete Buffer" })
  map("n", "<leader>bD", function() snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
  map("n", "<leader>bo", function() snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
else
  -- Fallback without snacks
  map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
  map("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete Other Buffers" })
  map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete Other Buffers" })
end

-- Pin buffer (if using snacks)
if require("nixCatsUtils").enableForCategory("util") then
  local snacks_keymap = require("lzextras").keymap("snacks.nvim")
  snacks_keymap.set("n", "<leader>bp", function()
    require("snacks").toggle.pin():toggle()
  end, { desc = "Toggle Pin" })

  snacks_keymap.set("n", "<leader>bP", function()
    require("snacks").toggle.pin():toggle({ clear = true })
  end, { desc = "Delete Non-Pinned Buffers" })
end

-- Buffer picker (using snacks)
if require("nixCatsUtils").enableForCategory("util") then
  local snacks_keymap = require("lzextras").keymap("snacks.nvim")
  snacks_keymap.set("n", "<leader>fb", function()
    require("snacks").picker.buffers()
  end, { desc = "Buffers" })
end