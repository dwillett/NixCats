return {
  "grug-far.nvim",
  for_cat = {
    cat = "editor",
    default = true,
  },
  on_require = { "grug-far" },
  after = function(plugin)
    require("grug-far").setup()
  end,
}
