local map = vim.keymap.set

map("n", "<leader><tab>j", "<cmd>Tabby jump_to_tab<CR>", { desc = "Jump Mode" })
map("n", "<leader><tab>r", function()
  local name = vim.fn.input({ prompt = "Tab name:" })
  if name then
    return vim.cmd("Tabby rename_tab " .. name)
  end
end, { desc = "Rename Tab" })
