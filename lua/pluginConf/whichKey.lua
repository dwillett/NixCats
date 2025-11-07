-- <nixCats>/lua/pluginConf/whichKey.lua
-- Lazydev config

return {
  "which-key.nvim",
  for_cat = {
    cat = "editor",
    default = true,
  },
  lazy = false,
  after = function(plugin)
    require("which-key").setup({
      preset = "helix",
      delay = 0,
      notify = true,
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windown = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      show_help = true,
      show_keys = true,
    })
  end,
}
