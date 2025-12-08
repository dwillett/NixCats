-- <nixCats>/lua/pluginConf/init.lua
-- Lazy loaded plugins config

-- Register lze handler with the spec field 'for_cat' before any lazy loading
require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)
require("lze").register_handlers(require("nixCatsUtils.lzUtils").in_extra)

-- Bootstrap plugins if needed first
require("pluginConf.paq")

-- Plugin configs, with one call to lze
require("lze").load({
  { import = "pluginConf.aerial" },
  { import = "pluginConf.completion" },
  { import = "pluginConf.conform" },
  { import = "pluginConf.dap" },
  { import = "pluginConf.edgy" },
  { import = "pluginConf.ergoterm" },
  { import = "pluginConf.flash" },
  { import = "pluginConf.git" },
  { import = "pluginConf.grug-far" },
  { import = "pluginConf.lazydev" },
  { import = "pluginConf.lint" },
  { import = "pluginConf.lsp" },
  { import = "pluginConf.markdown" },
  { import = "pluginConf.mason" },
  { import = "pluginConf.mini" },
  { import = "pluginConf.neotest" },
  { import = "pluginConf.noice" },
  { import = "pluginConf.oil" },
  { import = "pluginConf.pomodoro" },
  { import = "pluginConf.shadowenv" },
  { import = "pluginConf.snacks" },
  { import = "pluginConf.tint" },
  { import = "pluginConf.theme" },
  { import = "pluginConf.treesitter" },
  { import = "pluginConf.trouble" },
  { import = "pluginConf.util" },
  { import = "pluginConf.whichKey" },
})
