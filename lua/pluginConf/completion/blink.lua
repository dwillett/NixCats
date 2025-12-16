return {
  -- Main plugin
  {
    "blink.cmp",
    for_cat = { cat = "coding", default = true },
    event = { "DeferredUIEnter" },
    on_require = { "blink" },
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("blink-copilot")
      vim.cmd.packadd("blink-ripgrep.nvim")
      vim.cmd.packadd("blink-emoji.nvim")
      vim.cmd.packadd("blink-cmp-spell")
      vim.cmd.packadd("blink.compat")
    end,
    after = function(plugin)
      local bl = require("blink.cmp")
      bl.setup({
        -- General completion settings
        completion = {
          keyword = { range = "full" },
          trigger = {
            show_on_keyword = true,
            show_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
          accept = { auto_brackets = { enabled = false } },
          menu = {
            auto_show = true,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            treesitter_highlighting = false,
          },
          ghost_text = { enabled = true },
        },
        -- Keymap
        keymap = {
          preset = "default",
          ["<C-n>"] = { "select_next" },
          ["<C-p>"] = { "select_prev" },
          ["<CR>"] = { "accept", "fallback" },
        },
        appearance = {
          -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
          kind_icons = {
            Copilot = "",
            Text = "󰉿",
            Method = "󰊕",
            Function = "󰊕",
            Constructor = "󰒓",

            Field = "󰜢",
            Variable = "󰆦",
            Property = "󰖷",

            Class = "󱡠",
            Interface = "󱡠",
            Struct = "󱡠",
            Module = "󰅩",

            Unit = "󰪚",
            Value = "󰦨",
            Enum = "󰦨",
            EnumMember = "󰦨",

            Keyword = "󰻾",
            Constant = "󰏿",

            Snippet = "󱄽",
            Color = "󰏘",
            File = "󰈔",
            Reference = "󰬲",
            Folder = "󰉋",
            Event = "󱐋",
            Operator = "󰪚",
            TypeParameter = "󰬛",
          },
        },

        -- Completion sources
        sources = {
          default = function(ctx)
            -- Default list of completion sources
            local sourceList = {
              "lsp",
              "path",
              "snippets",
              "buffer",
              "copilot",
              "ripgrep",
              "emoji",
            }
            -- Conditionally add sources
            if vim.bo.filetype == "lua" then
              table.insert(sourceList, "lazydev")
            end
            return sourceList
          end,
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              score_offset = 100,
              async = true,
            },
            path = {
              async = true,
            },
            ripgrep = {
              module = "blink-ripgrep",
              name = "Ripgrep",
              opts = {
                prefix_min_len = 3,
                context_size = 4,
                max_filesize = "1M",
                project_root_marker = {
                  ".git",
                  "flake.lock",
                  "uv.lock",
                },
              },
            },
            emoji = {
              module = "blink-emoji",
              name = "Emoji",
              score_offset = 15,
              opts = {
                insert = true,
              },
            },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
          },
        },
        -- Snippets
        snippets = {
          preset = "luasnip",
        },
        -- Signature help
        signature = { enabled = true },
      })
    end,
  },
}
