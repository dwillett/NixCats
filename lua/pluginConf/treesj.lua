-- <nixCats>/lua/pluginConf/treesj.lua
-- TreeSJ config - split/join with treesitter awareness

local toggle = function()
  require("treesj").toggle()
end

return {
  "treesj",
  for_cat = {
    cat = "editor",
    default = true,
  },
  on_plugin = { "nvim-treesitter" },
  keys = {
    { "gS", toggle, desc = "Toggle split/join" },
  },
  after = function(plugin)
    require("treesj").setup({
      use_default_keymaps = false,
      max_join_length = 120,
    })
  end,
}
