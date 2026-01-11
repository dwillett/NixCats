return {
  {
    "canopy-nvim",
    for_cat = {
      cat = "editor",
      default = true,
    },
    lazy = false,
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("canopy-git-nvim")
      vim.cmd.packadd("canopy-graphite-nvim")
    end,
    after = function(plugin)
      require("canopy").setup({
        extensions = {
          git = {},
          graphite = {},
        },
        views = {
          graphite = {
            layout = {
              type = "row",
              children = {
                { layout = "graphite.sidebar", type = "col", size = 40 },
                {
                  type = "col",
                  size = "flex",
                  children = {
                    { editor = true, size = "flex" },
                    { panel = "core.log_viewer", size = 16 },
                  },
                },
              },
            },
          },
          coding = {
            layout = {
              type = "row",
              children = {
                {
                  type = "col",
                  size = "20%",
                  children = {
                    { panel = "aerial", size = "flex" },
                    { spacer = true },
                    { panel = "neotest", size = "flex" },
                  },
                },
                {
                  type = "col",
                  size = "flex",
                  children = {
                    { editor = true, size = "flex" },
                    { panel = "core.log_viewer", size = 16 },
                  },
                },
              },
            },
          },
        },
      })
    end,
  },
}
