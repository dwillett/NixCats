local map = vim.keymap.set

if require("nixCatsUtils").enableForCategory("util") then
  local ergoterm = require("ergoterm")

  map("n", "<leader>on", ":TermNew layout=below<CR>", { desc = "New terminal (below)", noremap = true, silent = true })
  map("n", "<leader>ov", ":TermNew layout=right<CR>", { desc = "New terminal (right)", noremap = true, silent = true })
  map("n", "<leader>of", ":TermNew layout=float<CR>", { desc = "New terminal (float)", noremap = true, silent = true })
  map("n", "<leader>ot", ":TermNew layout=tab<CR>", { desc = "New terminal (tab)", noremap = true, silent = true })

  map("n", "<leader>ol", ":TermSelect<CR>", { desc = "Select terminal", noremap = true, silent = true })

  map({ "n", "x" }, "<leader>os", ":TermSend! new_line=false<CR>", { desc = "Send text", noremap = true, silent = true })
  map({ "n", "x" }, "<leader>ox", ":TermSend! action=open<CR>", { desc = "Send text", noremap = true, silent = true })

  -- Terminal mappings
  map("t", "<C-Space>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
  map("t", "<C-Left>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  map("t", "<C-Down>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  map("t", "<C-Up>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  map("t", "<C-Right>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
  -- Resize in terminal mode (matches normal mode C-h/j/k/l)
  map("t", "<C-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
  map("t", "<C-j>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
  map("t", "<C-k>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
  map("t", "<C-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
  local function toggle_bottom_terminal()
    -- With pinned views, edgy.toggle() will call the open function when expanding
    require("edgy").toggle("bottom")
  end
  map("n", "<C-/>", toggle_bottom_terminal, { desc = "Toggle bottom terminal", noremap = true, silent = true })
  map("n", "<C-_>", toggle_bottom_terminal, { desc = "which_key_ignore" })
  map("t", "<C-/>", toggle_bottom_terminal, { desc = "Toggle bottom terminal" })
  map("t", "<C-_>", toggle_bottom_terminal, { desc = "which_key_ignore" })
end
