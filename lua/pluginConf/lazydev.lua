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
        { path = "${3rd}/luassert/library", words = { "assert" } },
        { path = "${3rd}/busted/library", words = { "it%(", "describe%(" } },
        {
          words = { "nixCats" },
          path = (require("nixCats").nixCatsPath or "") .. "/lua",
        },
      },
    })
  end,
}
