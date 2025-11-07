-- <nixCats>/lua/pluginConf/conform.lua
-- Code formatter config

return {
  "conform.nvim",
  for_cat = {
    cat = "formatting",
    default = true,
  },
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  on_require = { "conform" },
  after = function(plugin)
    require("conform").setup({
      -- Formatters by filetype
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        nix = { "alejandra" },
        c = { "clang-format" },
      },
      -- Default options
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      -- Formatter specific options
      formatters = {
        injected = { options = { ignore_errors = true } },
        stylua = {
          prepend_args = {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
          },
        },
      },
      -- Format on save
      format_on_save = function(bufnr)
        -- Disable with a variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Return options otherwise
        return {
          timeout_ms = 1000,
          lsp_format = "fallback",
        }
      end,
      -- Trying to fix things
      -- log_level = vim.log.levels.DEBUG,
    })
  end,
}
