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
        layouts = {
          ["user.bottom-drawer"] = {
            panels = {
              {
                col = {
                  {
                    row = {
                      {
                        tabs = {
                          {
                            adapter = {
                              ft = "trouble",
                              title = "Diagnostics",
                              match = function(_, win)
                                return vim.w[win].trouble and vim.w[win].trouble.mode == "diagnostics"
                              end,
                            },
                          },
                          {
                            adapter = {
                              ft = "trouble",
                              title = "Quickfix",
                              match = function(_, win)
                                return vim.w[win].trouble and vim.w[win].trouble.mode == "qflist"
                              end,
                            },
                          },
                          {
                            adapter = {
                              ft = "trouble",
                              title = "Symbols",
                              match = function(_, win)
                                return vim.w[win].trouble and vim.w[win].trouble.mode == "symbols"
                              end,
                            },
                          },
                          {
                            adapter = {
                              ft = "trouble",
                              title = "LSP",
                              match = function(_, win)
                                return vim.w[win].trouble and vim.w[win].trouble.mode == "lsp"
                              end,
                            },
                          },
                          {
                            adapter = {
                              ft = "trouble",
                              title = "Locations",
                              match = function(_, win)
                                return vim.w[win].trouble and vim.w[win].trouble.mode == "loclist"
                              end,
                            },
                          },
                        },
                      },
                      { adapter = { ft = "qf", title = "QuickFix" } },
                      {
                        adapter = {
                          title = "Help",
                          match = function(buf)
                            return vim.bo[buf].buftype == "help"
                          end,
                        },
                      },
                      {
                        adapter = {
                          ft = "noice",
                          title = "Noice",
                          match = function(_, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                          end,
                        },
                      },
                    },
                  },
                  {
                    tabs = {
                      {
                        adapter = {
                          ft = "ergoterm",
                          title = "Terminal",
                          match = function(buf, win)
                            -- Skip floating windows (lazygit, etc.)
                            if vim.api.nvim_win_get_config(win).relative ~= "" then
                              return false
                            end
                            local bufname = vim.api.nvim_buf_get_name(buf)
                            -- Claude terminal goes to the right, everything else goes bottom
                            return not bufname:match("claude")
                          end,
                        },
                      },
                      {
                        module = "core.log_viewer",
                      },
                      {
                        adapter = {
                          ft = "neotest-output-panel",
                          title = "Test Output",
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        },
        views = {
          -- Git/Graphite view: graphite sidebar (stage, stack, events, stash) on left
          graphite = {
            layout = {
              { layout = "graphite.sidebar", type = "col", size = 40 },
              {
                col = {
                  { editor = true },
                  { layout = "user.bottom-drawer", size = 16 },
                },
              },
            },
          },
          -- Testing view: neotest summary on left
          testing = {
            layout = {
              { adapter = "neotest", ft = "neotest-summary", size = 40 },
              {
                col = {
                  { editor = true },
                  { layout = "user.bottom-drawer", size = 16 },
                },
              },
            },
          },
          -- Coding view: aerial outline on left
          coding = {
            layout = {
              { adapter = "aerial", size = 40 },
              {
                col = {
                  { editor = true, size = "flex" },
                  { layout = "user.bottom-drawer", size = 16 },
                },
              },
            },
          },
        },
      })
    end,
  },
}
