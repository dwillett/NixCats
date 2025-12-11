-------------------------------------------------
-- Latex files behavior
-------------------------------------------------

-- F5 renders us in Glow, Shift-F5 toggles markdown rendering
vim.keymap.set("n", "<F5>", "<cmd>Glow<CR>", { desc = "Render markdown in window", buffer = true })
vim.keymap.set("n", "<F17>", "<cmd>RenderMarkdown buf_toggle<CR>", { desc = "Render markdown in page", buffer = true })
