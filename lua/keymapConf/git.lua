-- Git keymaps following LazyVim conventions
-- https://www.lazyvim.org/keymaps#git

local map = vim.keymap.set

-- Gitsigns integration (if available)
if require("nixCatsUtils").enableForCategory("editor") then
  local gitsigns_keymap = require("lzextras").keymap("gitsigns.nvim")

  -- Hunk operations (LazyVim style - using gh prefix for hunks)
  map("n", "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk" })
  map("n", "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Hunk" })
  gitsigns_keymap.set("v", "<leader>ghs", function()
    require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage Hunk" })
  gitsigns_keymap.set("v", "<leader>ghr", function()
    require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset Hunk" })

  map("n", "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage Buffer" })
  map("n", "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo Stage Hunk" })
  map("n", "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset Buffer" })
  map("n", "<leader>ghp", "<cmd>Gitsigns preview_hunk_inline<cr>", { desc = "Preview Hunk Inline" })

  -- Blame operations
  gitsigns_keymap.set("n", "<leader>ghb", function()
    require("gitsigns").blame_line({ full = true })
  end, { desc = "Blame Line" })
  map("n", "<leader>ghB", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle Line Blame" })

  -- Diff operations
  map("n", "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff This" })
  gitsigns_keymap.set("n", "<leader>ghD", function()
    require("gitsigns").diffthis("~")
  end, { desc = "Diff This ~" })

  -- Navigation
  map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next Hunk" })
  map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev Hunk" })

  -- Text object
  gitsigns_keymap.set({ "o", "x" }, "ih", require("gitsigns").select_hunk, { desc = "GitSigns Select Hunk" })
end

-- Snacks git integration (if available)
if require("nixCatsUtils").enableForCategory("util") then
  local snacks = require("snacks")
  local snacks_keymap = require("lzextras").keymap("snacks.nvim")

  -- LazyGit integration
  snacks_keymap.set("n", "<leader>gg", function()
    snacks.lazygit()
  end, { desc = "LazyGit (Root Dir)" })
  snacks_keymap.set("n", "<leader>gG", function()
    snacks.lazygit({ cwd = vim.fn.expand("%:p:h") })
  end, { desc = "LazyGit (cwd)" })
  snacks_keymap.set("n", "<leader>gf", function()
    snacks.lazygit.log_file()
  end, { desc = "LazyGit Current File History" })
  snacks_keymap.set("n", "<leader>gl", function()
    snacks.lazygit.log()
  end, { desc = "LazyGit Log" })

  -- Git browse
  snacks_keymap.set({ "n", "x" }, "<leader>gB", function()
    snacks.gitbrowse()
  end, { desc = "Git Browse (open)" })
  snacks_keymap.set({ "n", "x" }, "<leader>gY", function()
    snacks.gitbrowse({
      open = function(url)
        vim.fn.setreg("+", url)
      end,
      notify = true,
    })
  end, { desc = "Git Browse (copy)" })

  -- Git blame
  snacks_keymap.set("n", "<leader>gb", function()
    snacks.git.blame_line()
  end, { desc = "Git Blame Line" })

  -- gh
  snacks_keymap.set("n", "<leader>gi", function()
    Snacks.picker.gh_issue()
  end, { desc = "GitHub Issues (open)" })
  snacks_keymap.set("n", "<leader>gI", function()
    Snacks.picker.gh_issue({ state = "all" })
  end, { desc = "GitHub Issues (all)" })
  snacks_keymap.set("n", "<leader>gp", function()
    Snacks.picker.gh_pr()
  end, { desc = "GitHub Pull Requests (open)" })
  snacks_keymap.set("n", "<leader>gP", function()
    Snacks.picker.gh_pr({ state = "all" })
  end, { desc = "GitHub Pull Requests (all)" })

  -- Note: Most git file operations moved to search.lua under <leader>s prefix
end
