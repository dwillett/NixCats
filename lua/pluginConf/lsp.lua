-- <nixCats>/lua/pluginConf/lsp.lua
-- LSP config for lsp server status

return {
  "nvim-lspconfig",
  for_cat = {
    cat = "lsp",
    default = true,
  },
  event = { "FileType" },
  cmd = {
    "LspInfo",
    "LspStart",
    "LspStop",
    "LspRestart",
  },
  on_require = { "lspconfig" },
  after = function(plugin)
    vim.lsp.config("sorbet", {
      cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
    })
    vim.lsp.enable("sorbet")
  end,
}
