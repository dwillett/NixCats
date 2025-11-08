if not vim.g.vscode then
  return {}
end

local enabled = {
  "leap.nvim",
  "mini.ai",
  "mini.comment",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "snacks.nvim",
}

local vscode = require("vscode")
vim.g.snacks_animate = false

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymapsDefaults",
  callback = function()
    -- VSCode-specific keymaps for search and navigation
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    vim.keymap.set("n", "<leader>/", function()
      vscode.call("workbench.action.findInFiles")
    end)
    vim.keymap.set("n", "<leader>ss", function()
      vscode.call("workbench.action.gotoSymbol")
    end)

    -- Toggle VS Code integrated terminal
    for _, lhs in ipairs({ "<leader>ft", "<leader>fT", "<c-/>" }) do
      vim.keymap.set("n", lhs, function()
        vscode.call("workbench.action.terminal.toggleTerminal")
      end)
    end

    -- Navigate VSCode tabs like buffers
    vim.keymap.set("n", "<S-h>", function()
      vscode.call("workbench.action.previousEditor")
    end)
    vim.keymap.set("n", "<S-l>", function()
      vscode.call("workbench.action.nextEditor")
    end)
  end,
})

return {
  {
    "snacks.nvim",
    after = function(plugin)
      require("snacks").setup({
        bigfile = { enabled = false },
        dashboard = { enabled = false },
        indent = { enabled = false },
        input = { enabled = false },
        notifier = { enabled = false },
        picker = { enabled = false },
        quickfile = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    after = function(plugin)
      require("nvim-treesitter.configs").setup({
        highlight = { enable = false },
      })
    end,
  },
  {
    "nvim-treesitter-textobjects",
    after = function(plugin)
      require("treesitter-context").setup({
        enable = false,
      })
    end,
  },
}
