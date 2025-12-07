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
  map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
  map("t", "<C-Left>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  map("t", "<C-Down>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  map("t", "<C-Up>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  map("t", "<C-Right>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
  local function focus_terminal()
    local target = ergoterm.get_target_for_bang()
    if target then
      target:focus()
    else
      local default_term = ergoterm.get_by_name("default")
      if default_term then
        default_term:focus()
      end
    end
  end
  map("n", "<C-/>", focus_terminal, { desc = "Focus terminal", noremap = true, silent = true })
  map("n", "<C-_>", focus_terminal, { desc = "which_key_ignore" })
  map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
  map("t", "<C-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
end
