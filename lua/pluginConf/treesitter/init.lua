-- <nixCats>/lua/pluginConf/treesitter/init.lua
-- Treesitter config

return {
  {
    "nvim-treesitter-context",
    for_cat = {
      "treesitter",
      default = true,
    },
    on_plugin = { "nvim-treesitter" },
    after = function(plugin)
      require("treesitter-context").setup({
        enable = true,
        line_numbers = true,
      })
    end,
  },
  {
    "nvim-treesitter-textobjects",
    for_cat = {
      cat = "treesitter",
      default = true,
    },
    on_plugin = { "nvim-treesitter" },
    after = function(plugin)
      require("nvim-treesitter-textobjects").setup({
        require("pluginConf.treesitter.textobjects"),
      })
    end,
  },
  {
    "nvim-treesitter",
    for_cat = {
      cat = "treesitter",
      default = true,
    },
    dep_of = {
      "aerial.nvim",
      "render-markdown.nvim",
    },
    lazy = false,
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("nvim-treesitter-textobjects")
    end,
    after = function(plugin)
      -- Configure treesitter
      require("nvim-treesitter").setup()
    end,
  },
}
