-- <nixCats>/lua/pluginConf/aerial.lua
-- Aerial config

return {
  "aerial.nvim",
  for_cat = {
    cat = "ui",
    default = true,
  },
  cmd = {
    "AerialToggle",
    "AerialOpen",
    "AerialOpenAll",
    "AerialClose",
    "AerialCloseAll",
    "AerialNext",
    "AerialPrev",
    "AerialGo",
    "AerialInfo",
    "AerialNavToggle",
    "AerialNavOpen",
    "AerialNavClose",
  },
  dep_of = {
    "lualine.nvim",
  },
  require = { "aerial" },
  ft = "lua",
  after = function(plugin)
    require("aerial").setup({
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man", "asciidoc" },
      show_guides = true,
      layout = {
        resize_to_content = false,
        default_direction = "prefer_left",
        win_opts = {
          winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
          winfixbuf = true,
          signcolumn = "yes",
          statuscolumn = " ",
        },
      },
      guides = {
        mid_item = "╠═",
        last_item = "╚═",
        nested_top = "║ ",
        whitespace = "  ",
      },
      lsp = {
        diagnostics_trigger_update = false,
      },
      nav = {
        preview = true,
        keymaps = {
          ["<CR>"] = "actions.jump",
          ["<C-v>"] = "actions.jump_vsplit",
          ["<C-s>"] = "actions.jump_split",
          ["q"] = "actions.close",
          ["<Esc>"] = "actions.close",
        },
      },
    })
  end,
}
