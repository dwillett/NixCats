-- <nixCats>/lua/pluginConf/lazydev.lua
-- Lazydev config

return {
  "lazydev.nvim",
  for_cat = {
    cat = "lsp",
    default = true,
  },
  cmd = { "LazyDev" },
  ft = "lua",
  after = function(plugin)
    require("lazydev").setup({
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        {
          words = { "nixCats" },
          path = (require("nixCats").nixCatsPath or "") .. "/lua",
        },
      },
    })
  end,
}
