-- Search keymaps following LazyVim conventions
-- https://www.lazyvim.org/keymaps#search

local map = vim.keymap.set

-- If using snacks picker
if require("nixCatsUtils").enableForCategory("util") then
  local snacks = require("snacks")
  local snacks_keymap = require("lzextras").keymap("snacks.nvim")

  -- Core file/search mappings (LazyVim style)
  snacks_keymap.set("n", "<leader><space>", function()
    snacks.picker.files()
  end, { desc = "Find Files (Root Dir)" })
  snacks_keymap.set("n", "<leader>,", function()
    snacks.picker.buffers()
  end, { desc = "Switch Buffer" })
  snacks_keymap.set("n", "<leader>/", function()
    snacks.picker.grep()
  end, { desc = "Grep (Root Dir)" })
  snacks_keymap.set("n", "<leader>:", function()
    snacks.picker.command_history()
  end, { desc = "Command History" })
  snacks_keymap.set("n", "<leader>`", function()
    snacks.picker.marks()
  end, { desc = "Marks" })

  -- find
  snacks_keymap.set("n", "<leader>fb", function()
    snacks.picker.buffers()
  end, { desc = "Buffers" })
  snacks_keymap.set("n", "<leader>fc", function()
    snacks.picker.files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Find Config File" })
  snacks_keymap.set("n", "<leader>ff", function()
    snacks.picker.files()
  end, { desc = "Find Files (Root Dir)" })
  snacks_keymap.set("n", "<leader>fF", function()
    snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Find Files (cwd)" })
  snacks_keymap.set("n", "<leader>fg", function()
    snacks.picker.git_files()
  end, { desc = "Find Files (git-files)" })
  snacks_keymap.set("n", "<leader>fr", function()
    snacks.picker.recent()
  end, { desc = "Recent" })
  snacks_keymap.set("n", "<leader>fR", function()
    snacks.picker.recent({ cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Recent (cwd)" })

  -- git
  snacks_keymap.set("n", "<leader>gc", function()
    snacks.picker.git_log_file()
  end, { desc = "Git Log File" })
  snacks_keymap.set("n", "<leader>gs", function()
    snacks.picker.git_status()
  end, { desc = "Git Status" })

  -- search
  snacks_keymap.set("n", '<leader>s"', function()
    snacks.picker.registers()
  end, { desc = "Registers" })
  snacks_keymap.set("n", "<leader>sa", function()
    snacks.picker.autocmds()
  end, { desc = "Auto Commands" })
  snacks_keymap.set("n", "<leader>sb", function()
    snacks.picker.lines()
  end, { desc = "Buffer" })
  snacks_keymap.set("n", "<leader>sB", function()
    snacks.picker.grep_buffers()
  end, { desc = "Grep Open Buffers" })
  snacks_keymap.set("n", "<leader>sc", function()
    snacks.picker.command_history()
  end, { desc = "Command History" })
  snacks_keymap.set("n", "<leader>sC", function()
    snacks.picker.commands()
  end, { desc = "Commands" })
  snacks_keymap.set("n", "<leader>sd", function()
    snacks.picker.diagnostics()
  end, { desc = "Document Diagnostics" })
  snacks_keymap.set("n", "<leader>sD", function()
    snacks.picker.diagnostics_buffer()
  end, { desc = "Workspace Diagnostics" })
  snacks_keymap.set("n", "<leader>sg", function()
    snacks.picker.grep()
  end, { desc = "Grep (Root Dir)" })
  snacks_keymap.set("n", "<leader>sG", function()
    snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Grep (cwd)" })
  snacks_keymap.set("n", "<leader>sh", function()
    snacks.picker.help()
  end, { desc = "Help Pages" })
  snacks_keymap.set("n", "<leader>sH", function()
    snacks.picker.highlights()
  end, { desc = "Search Highlight Groups" })
  snacks_keymap.set("n", "<leader>si", function()
    snacks.picker.icons()
  end, { desc = "Icons" })
  snacks_keymap.set("n", "<leader>sj", function()
    snacks.picker.jumps()
  end, { desc = "Jumplist" })
  snacks_keymap.set("n", "<leader>sk", function()
    snacks.picker.keymaps()
  end, { desc = "Key Maps" })
  snacks_keymap.set("n", "<leader>sl", function()
    snacks.picker.loclist()
  end, { desc = "Location List" })
  snacks_keymap.set("n", "<leader>sM", function()
    snacks.picker.man()
  end, { desc = "Man Pages" })
  snacks_keymap.set("n", "<leader>sm", function()
    snacks.picker.marks()
  end, { desc = "Jump to Mark" })
  snacks_keymap.set("n", "<leader>so", function()
    snacks.picker.vim_options()
  end, { desc = "Options" })
  snacks_keymap.set("n", "<leader>sR", function()
    snacks.picker.resume()
  end, { desc = "Resume" })
  snacks_keymap.set("n", "<leader>sq", function()
    snacks.picker.qflist()
  end, { desc = "Quickfix List" })
  snacks_keymap.set("n", "<leader>su", function()
    snacks.picker.undo()
  end, { desc = "Undo History" })

  -- Word search (similar to grep for word under cursor)
  snacks_keymap.set("n", "<leader>sw", function()
    snacks.picker.grep_word()
  end, { desc = "Word (Root Dir)" })
  snacks_keymap.set("n", "<leader>sW", function()
    snacks.picker.grep_word({ cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Word (cwd)" })

  -- Visual selection search
  snacks_keymap.set({ "x", "v" }, "<leader>sw", function()
    snacks.picker.grep_word({ mode = "v" })
  end, { desc = "Selection (Root Dir)" })
  snacks_keymap.set({ "x", "v" }, "<leader>sW", function()
    snacks.picker.grep_word({ mode = "v", cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Selection (cwd)" })

  -- Colorscheme picker
  snacks_keymap.set("n", "<leader>uC", function()
    snacks.picker.colorschemes()
  end, { desc = "Colorscheme with Preview" })
else
  -- Fallback if snacks is not available
  -- You could add telescope or fzf mappings here
  map("n", "<leader><space>", "<cmd>find .<cr>", { desc = "Find Files (basic)" })
  map("n", "<leader>,", "<cmd>ls<cr>:b<space>", { desc = "Switch Buffer (basic)" })
  map("n", "<leader>/", "<cmd>vimgrep //j **/*<left><left><left><left><left><left><left>", { desc = "Grep (basic)" })
end

-- Search and replace (using default vim or substitute plugin)
map({ "n", "x" }, "<leader>sr", ":%s/<C-r><C-w>//g<left><left>", { desc = "Replace word under cursor" })
if require("nixCatsUtils").enableForCategory("editor") then
  local grug_ok, grug = pcall(require, "grug-far")
  if grug_ok then
    map({ "n", "x" }, "<leader>sr", function()
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      grug.open({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      })
    end, { desc = "Search and Replace" })
  end
end
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Flash search integration (if available)
if require("nixCatsUtils").enableForCategory("editor") then
  local flash_ok, flash = pcall(require, "flash")
  if flash_ok then
    -- Flash keymaps following LazyVim
    map({ "n", "x", "o" }, "s", function()
      flash.jump()
    end, { desc = "Flash" })
    map({ "n", "x", "o" }, "S", function()
      flash.treesitter()
    end, { desc = "Flash Treesitter" })
    map("o", "r", function()
      flash.remote()
    end, { desc = "Remote Flash" })
    map({ "o", "x" }, "R", function()
      flash.treesitter_search()
    end, { desc = "Treesitter Search" })
    map("c", "<c-s>", function()
      flash.toggle()
    end, { desc = "Toggle Flash Search" })
  end
end
