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
    -- Format aerial symbols for winbar display
    local function aerial_winbar()
      local ok, aerial = pcall(require, "aerial")
      if not ok then
        return ""
      end
      local symbols = aerial.get_location(true)
      if not symbols or #symbols == 0 then
        return ""
      end
      local parts = {}
      for _, symbol in ipairs(symbols) do
        table.insert(parts, symbol.icon .. " " .. symbol.name)
      end
      return table.concat(parts, " › ")
    end
    -- Expose for winbar statusline expression
    _G.aerial_winbar = aerial_winbar

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

    -- Set up winbar for regular buffers
    vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "BufEnter" }, {
      group = vim.api.nvim_create_augroup("AerialWinbar", { clear = true }),
      callback = function()
        local winid = vim.api.nvim_get_current_win()
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local bt = vim.bo[bufnr].buftype
        local ft = vim.bo[bufnr].filetype

        -- Skip special buffers
        if bt ~= "" then
          return
        end

        -- Skip certain filetypes
        local skip_ft = { "neo-tree", "dashboard", "alpha", "starter", "snacks_dashboard", "aerial", "trouble" }
        for _, skip in ipairs(skip_ft) do
          if ft == skip then
            return
          end
        end

        -- Set winbar with aerial symbols
        vim.wo[winid].winbar = "%{%v:lua.aerial_winbar()%}"
      end,
    })
  end,
}
