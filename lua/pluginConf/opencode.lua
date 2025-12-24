-- <nixCats>/lua/pluginConf/oil.lua
-- Oil nvim; replacement for netrc
-- Not lazy loaded due to netrc setting

-- Configuring oil.nvim
return {
  "opencode.nvim",
  for_cat = {
    cat = "util",
    default = true,
  },
  on_require = { "opencode" },
  after = function(plugin)
    require("opencode").setup({})
  end,
}
