-- Noice keymaps following LazyVim conventions
-- https://www.lazyvim.org/keymaps#noicenvim

local map = vim.keymap.set

if require("nixCatsUtils").enableForCategory("ui") then
  local noice_ok, noice = pcall(require, "noice")
  if noice_ok then
    map({ "n", "i", "s" }, "<c-f>", function()
      if not require("noice.lsp").scroll(4) then
        return "<c-f>"
      end
    end, { silent = true, expr = true, desc = "Scroll Backward" })
    map({ "n", "i", "s" }, "<c-b>", function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
      end
    end, { silent = true, expr = true, desc = "Scroll Backward" })

    map("c", "<S-Enter>", function()
      noice.redirect(vim.fn.getcmdline())
    end, { desc = "Redirect Cmdline" })
    map("n", "<leader>snl", function()
      noice.cmd("last")
    end, { desc = "Noice Last Message" })
    map("n", "<leader>snh", function()
      noice.cmd("history")
    end, { desc = "Noice History" })
    map("n", "<leader>sna", function()
      noice.cmd("all")
    end, { desc = "Noice All" })
    map("n", "<leader>snd", function()
      noice.cmd("dismiss")
    end, { desc = "Dismiss All" })
    map("n", "<leader>snt", function()
      noice.cmd("pick")
    end, { desc = "Dismiss All" })
  end
end
