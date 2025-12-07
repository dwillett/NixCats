-- <nixCats>/lua/pluginConf/theme/lualine.lua
-- Status line + winbar config

-- lualine nvim setup
return {
  "lualine.nvim",
  for_cat = {
    cat = "ui",
    default = true,
  },
  event = { "DeferredUIEnter" },
  dep_of = { "tabby.nvim" },
  on_require = { "lualine" },
  after = function(plugin)
    local utils = require("lualine.utils.utils")
    local highlight = require("lualine.highlight")

    local diagnostics_message = require("lualine.component"):extend()

    diagnostics_message.default = {
      colors = {
        error = utils.extract_color_from_hllist(
          { "fg", "sp" },
          { "DiagnosticError", "LspDiagnosticsDefaultError", "DiffDelete" },
          "#e32636"
        ),
        warning = utils.extract_color_from_hllist(
          { "fg", "sp" },
          { "DiagnosticWarn", "LspDiagnosticsDefaultWarning", "DiffText" },
          "#ffa500"
        ),
        info = utils.extract_color_from_hllist(
          { "fg", "sp" },
          { "DiagnosticInfo", "LspDiagnosticsDefaultInformation", "DiffChange" },
          "#ffffff"
        ),
        hint = utils.extract_color_from_hllist(
          { "fg", "sp" },
          { "DiagnosticHint", "LspDiagnosticsDefaultHint", "DiffAdd" },
          "#273faf"
        ),
      },
    }
    function diagnostics_message:init(options)
      diagnostics_message.super:init(options)
      self.options.colors = vim.tbl_extend("force", diagnostics_message.default.colors, self.options.colors or {})
      self.highlights = { error = "", warn = "", info = "", hint = "" }
      self.highlights.error = highlight.create_component_highlight_group(
        { fg = self.options.colors.error },
        "diagnostics_message_error",
        self.options
      )
      self.highlights.warn = highlight.create_component_highlight_group(
        { fg = self.options.colors.warn },
        "diagnostics_message_warn",
        self.options
      )
      self.highlights.info = highlight.create_component_highlight_group(
        { fg = self.options.colors.info },
        "diagnostics_message_info",
        self.options
      )
      self.highlights.hint = highlight.create_component_highlight_group(
        { fg = self.options.colors.hint },
        "diagnostics_message_hint",
        self.options
      )
    end

    function diagnostics_message:update_status(is_focused)
      local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
      local diagnostics = vim.diagnostic.get(0, { lnum = r - 1 })
      if #diagnostics > 0 then
        local top = diagnostics[1]
        for _, d in ipairs(diagnostics) do
          if d.severity < top.severity then
            top = d
          end
        end
        local icons = { " ", " ", " ", " " }
        local hl = {
          self.highlights.error,
          self.highlights.warn,
          self.highlights.info,
          self.highlights.hint,
        }
        return highlight.component_format_highlight(hl[top.severity])
          .. icons[top.severity]
          .. " "
          .. utils.stl_escape(top.message)
      else
        return ""
      end
    end

    require("lualine").setup({
      options = {
        theme = "catppuccin",
        icons_enabled = true,
        globalstatus = true,
        component_separators = {
          left = "",
          right = "",
        },
        section_separators = {
          left = "",
          right = "",
        },
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = {
          {
            "branch",
            fmt = function(str)
              if #str > 30 then
                return str:sub(1, 30) .. "…"
              else
                return str
              end
            end,
          },
          "diff",
          "filename",
        },
        lualine_c = {
          {
            diagnostics_message,
            colors = {
              error = "#BF616A",
              warn = "#EBCB8B",
              info = "#A3BE8C",
              hint = "#88C0D0",
            },
          },
        },
        lualine_x = {
          "encoding",
          "filetype",
          function()
            local ok, pomo = pcall(require, "pomo")
            if not ok then
              return ""
            end

            local timer = pomo.get_first_to_finish()
            if timer == nil then
              return ""
            end

            return "󰄉 " .. tostring(timer)
          end,
        },
        lualine_y = {
          "progress",
        },
        lualine_z = {
          "location",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
