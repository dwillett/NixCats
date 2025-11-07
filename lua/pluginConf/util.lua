-- <nixCats>/lua/pluginConf/util.lua
-- Utility functions

return {
  { -- Library plugins
    "plenary.nvim",
    for_cat = {
      cat = "util",
      default = true,
    },
    dep_of = {
      "mkdnflow.nvim",
      "obsidian.nvim",
      "telescope.nvim",
    },
    on_require = { "plenary" },
  },
}
