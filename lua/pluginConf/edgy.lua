-- <nixCats>/lua/pluginConf/edgy.lua
-- Edgy.nvim - window layout management

return {
  "edgy.nvim",
  for_cat = {
    cat = "util",
    default = true,
  },
  on_require = { "edgy" },
  event = { "DeferredUIEnter" },
  after = function(_)
    require("edgy").setup({
      -- Bottom: diagnostics, quickfix, terminal, help
      bottom = {
        {
          ft = "canopy-output",
          size = { height = 0.3 },
        },
        {
          ft = "dap-view",
          size = { height = 0.3 },
        },
        {
          ft = "dap-repl",
          size = { height = 0.3 },
        },
        {
          ft = "trouble",
          size = { height = 0.3 },
          wo = { winhl = "Normal:Normal" },
          filter = function(_, win)
            return vim.w[win].trouble
              and vim.w[win].trouble.mode ~= "symbols"
              and vim.w[win].trouble.mode ~= "lsp_document_symbols"
          end,
        },
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        {
          ft = "ergoterm",
          title = "Terminal",
          size = { height = 0.3 },
          filter = function(buf, win)
            -- Skip floating windows (lazygit, etc.)
            if vim.api.nvim_win_get_config(win).relative ~= "" then
              return false
            end
            local bufname = vim.api.nvim_buf_get_name(buf)
            -- Claude terminal goes to the right, everything else goes bottom
            return not bufname:match("claude")
          end,
        },
        {
          ft = "noice",
          title = "Noice",
          size = { height = 0.3 },
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        {
          ft = "neotest-output-panel",
          title = "Test Output",
          size = { height = 0.3 },
        },
        {
          ft = "DiffviewFileHistory",
          title = "File History",
          size = { height = 0.3 },
        },
      },

      -- Left: symbols, outline, neogit status, diffview
      left = {
        {
          ft = "aerial",
          title = "Symbols",
          size = { width = 0.18 },
        },
        {
          ft = "trouble",
          title = "Symbols",
          size = { width = 0.18 },
          wo = { winhl = "Normal:Normal" },
          filter = function(_, win)
            return vim.w[win].trouble
              and (vim.w[win].trouble.mode == "symbols" or vim.w[win].trouble.mode == "lsp_document_symbols")
          end,
        },
        {
          ft = "neotest-summary",
          title = "Tests",
          size = { width = 0.18 },
        },
        {
          ft = "canopy-stack",
          title = "Stacks",
          size = { width = 0.18 },
        },
        {
          ft = "canopy-stage",
          title = "Stage",
          size = { width = 0.18 },
        },
        {
          ft = "canopy-stash",
          title = "Stash",
          size = { width = 0.18 },
        },
        {
          ft = "NeogitStatus",
          title = "Git Status",
          size = { width = 0.18 },
        },
        {
          ft = "DiffviewFiles",
          title = "Diff Files",
          size = { width = 0.18 },
        },
      },

      -- Right: right-side terminals (like claude)
      right = {
        {
          ft = "ergoterm",
          title = "Claude",
          size = { width = 0.36 },
          filter = function(buf, win)
            -- Skip floating windows (lazygit, etc.)
            if vim.api.nvim_win_get_config(win).relative ~= "" then
              return false
            end
            local bufname = vim.api.nvim_buf_get_name(buf)
            return bufname:match("claude")
          end,
        },
        {
          ft = "grug-far",
          title = "Find and Replace",
        },
      },

      -- Animation settings
      animate = {
        enabled = false,
      },

      -- Prevent edge windows from taking over when no main window exists
      exit_when_last = true,

      -- Keymaps for resizing (matches general.lua C-h/j/k/l pattern)
      keys = {
        ["<C-l>"] = function(win)
          win:resize("width", 2)
        end,
        ["<C-h>"] = function(win)
          win:resize("width", -2)
        end,
        ["<C-j>"] = function(win)
          win:resize("height", 2)
        end,
        ["<C-k>"] = function(win)
          win:resize("height", -2)
        end,
      },

      options = {
        left = { size = 30 },
        bottom = { size = 10 },
        right = { size = 30 },
        top = { size = 10 },
      },

      close_when_all_hidden = false,
    })

    -- Clear edgy highlight groups to inherit transparency from Normal
    vim.api.nvim_set_hl(0, "EdgyNormal", { link = "Normal" })
    vim.api.nvim_set_hl(0, "EdgyTitle", { link = "Title" })
  end,
}
