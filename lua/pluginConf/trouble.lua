-- <nixCats>/lua/pluginConf/trouble.lua

return {
  "trouble.nvim",
  for_cat = {
    cat = "editor",
    default = true,
  },
  dep_of = {
    "lualine.nvim",
  },
  cmd = { "Trouble" },
  -- We want deferreduienter to modify the gutter icons
  event = { "DeferredUIEnter" },
  after = function(plugin)
    require("trouble").setup({
      picker = {
        actions = require("trouble.sources.snacks").actions,
        win = {
          input = {
            keys = {
              ["<c-t>"] = {
                "trouble_open",
                mode = { "n", "i" },
              },
            },
          },
        },
      },
    })

    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      callback = function()
        vim.cmd([[Trouble qflist open]])
      end,
    })
  end,
}
