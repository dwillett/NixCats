-- <nixCats>/lua/pluginConf/git.lua
-- Git tools config

return {
  { -- Git status signs in the num column
    "gitsigns.nvim",
    for_cat = {
      cat = "editor",
      default = true,
    },
    on_require = { "gitsigns" },
    cmd = { "Gitsigns" },
    event = { "DeferredUIEnter" },
    after = function(plugin)
      require("gitsigns").setup({
        numhl = false,
        attach_to_untracked = false,
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        signs_staged = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
        },
      })
    end,
  },
}
