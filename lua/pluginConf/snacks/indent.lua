-- <nixCats>/lua/pluginConf/snacks/indent.lua
-- Indent config

-- Configuring dashboard
return {
  enabled = true,
  char = "│",
  only_scope = false,
  only_current = false,
  scope = {
    enabled = true,
    priority = 200,
    underline = false,
    only_current = false,
    hl = "SnacksIndentScope",
  },
  chunk = {
    enabled = false,
  },
}
