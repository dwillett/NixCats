-- <nixCats>/lua/pluginConf/diffview.lua
-- Diffview.nvim - Git diff and merge tool

return {
  "diffview.nvim",
  for_cat = {
    cat = "editor",
    default = true,
  },
  dep_of = { "neogit" },
  on_require = { "diffview" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
    { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "File History (repo)" },
  },
  after = function(_)
    require("diffview").setup({
      enhanced_diff_hl = true,
      use_icons = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_horizontal",
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        listing_style = "tree",
        win_config = {
          position = "left",
          width = 35,
        },
      },
    })
  end,
}
