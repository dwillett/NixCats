-- <nixCats>/lua/pluginConf/markdown.lua
-- Markdown config

return {
  { -- Preview
    "glow.nvim",
    for_cat = {
      cat = "markdown",
      default = true,
    },
    ft = { "markdown" },
    on_require = { "glow" },
    cmd = { "Glow" },
  },
  { -- Navigating markdown links
    "mkdnflow.nvim",
    for_cat = {
      cat = "markdown",
      default = true,
    },
    ft = { "markdown", "md", "rmd" },
    on_plugin = { "nvim-cmp" },
    on_require = { "mkdnflow" },
    after = function(plugin)
      require("mkdnflow").setup({
        modules = {
          cmp = true,
        },
      })
    end,
  },
  { -- Markdown rendering
    "render-markdown.nvim",
    for_cat = {
      cat = "markdown",
      default = true,
    },
    ft = { "markdown" },
    cmd = { "RenderMarkdown" },
    after = function(plugin)
      require("render-markdown").setup({
        enabled = true,
        render_modes = { "n", "c", "t" },
        latex = {
          enabled = false,
        },
        max_file_size = 10.0,
        pipe_table = {
          border = {
            "╔",
            "╤",
            "╗",
            "╟",
            "┼",
            "╢",
            "╚",
            "╧",
            "╝",
            "│",
            "─",
          },
        },
      })
    end,
  },
}
