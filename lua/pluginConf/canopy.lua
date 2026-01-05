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
      })
      local graphite_view = nil
      vim.keymap.set("n", "<leader>cv", function()
        if not graphite_view then
          graphite_view = require("canopy.core.view").new({
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
          })
        end
        graphite_view:toggle()
      end)
    end,
  },
}
