return {
  {
    "canopy-nvim",
    for_cat = {
      cat = "editor",
      default = true,
    },
    on_require = { "canopy" },
    cmd = {
      "Canopy",
    },
    keys = {
      { "<leader>gt", "<cmd>Canopy view dev<cr>", desc = "Toggle Canopy view" },
    },
    after = function(plugin)
      require("canopy").setup({
        git = {
          stage = { position = "left", size = 40 },
        },
        graphite = {
          stack = { position = "left", size = 40 },
        },
        keymaps = {
          global = { open = "<leader>gt" },
        },
      })
    end,
  },
}
