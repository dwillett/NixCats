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
        default_view = "graphite",
        views = {
          -- Git/Graphite view: graphite sidebar (stage, stack, events, stash) on left
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
          -- Testing view: neotest summary on left
          testing = {
            layout = {
              type = "row",
              children = {
                { panel = "neotest", size = 40 },
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
          -- Coding view: aerial outline on left
          coding = {
            layout = {
              type = "row",
              children = {
                { panel = "aerial", size = 40 },
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
