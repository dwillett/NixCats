-- <nixCats>/lua/pluginConf/flash.lua
-- Flash config

return {
  "flash.nvim",
  for_cat = {
    cat = "editor",
    default = true,
  },
  on_require = { "flash" },
  after = function(plugin)
    require("flash").setup({
      labels = "arstgmneioqwfpbjluyzxcdvkh",
    })
  end,
}
