-- <nixCats>/lua/pluginConf/neogit.lua
-- Neogit - Git interface for Neovim

local toggle_neogit_status = function()
  require("neogit").open({ kind = "split" })
end

return {
  "neogit",
  for_cat = {
    cat = "editor",
    default = true,
  },
  on_require = { "neogit" },
  cmd = { "Neogit" },
  keys = {
    { "<leader>gn", toggle_neogit_status, desc = "Neogit" },
    { "<C-s>g", toggle_neogit_status, desc = "Neogit" },
  },
  after = function(_)
    require("neogit").setup({
      disable_hint = true,
      auto_refresh = true,
      sort_branches = "-committerdate",
      filewatcher = {
        enabled = true,
        interval = 1000,
      },
      integrations = {
        diffview = true,
        snacks = true,
      },
      -- Status buffer specific settings
      status = {
        show_head_commit_hash = false,
        HEAD_folded = true,
        HEAD_padding = 3,
        recent_commit_count = 10,
        mode_padding = 2,
        mode_text = {
          M = "M",
          N = "N",
          A = "A",
          D = "D",
          C = "C",
          U = "U",
          R = "R",
          T = "T",
          DD = "DD",
          AU = "AU",
          UD = "UD",
          UA = "UA",
          DU = "DU",
          AA = "AA",
          UU = "UU",
          ["?"] = "?",
        },
      },
      -- Commit editor settings
      commit_editor = {
        kind = "auto",
      },
      -- Log viewer settings
      log_view = {
        kind = "tab",
      },
      -- Rebase editor settings
      rebase_editor = {
        kind = "auto",
      },
      -- Merge editor settings
      merge_editor = {
        kind = "auto",
      },
      -- Signs for various git statuses
      signs = {
        hunk = { "", "" },
        item = { ">", "v" },
        section = { ">", "v" },
      },
      sections = {
        sequencer = {
          hidden = true,
        },
        stashes = {
          folded = true,
        },
        unmerged_upstream = {
          folded = true,
          hidden = true,
        },
        unmerged_pushRemote = {
          folded = true,
          hidden = true,
        },
      },
    })
  end,
}
