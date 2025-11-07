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
    })
  end,
}
