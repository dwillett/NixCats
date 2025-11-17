-- <nixCats>/lua/pluginConf/theme/tabline.lua
-- Tabline config

local function lsp_diag(buf)
  local diagnostics = vim.diagnostic.get(buf)
  local count = { 0, 0, 0, 0 }

  for _, diagnostic in ipairs(diagnostics) do
    count[diagnostic.severity] = count[diagnostic.severity] + 1
  end
  if count[1] > 0 then
    return vim.bo[buf].modified and "" or ""
  elseif count[2] > 0 then
    return vim.bo[buf].modified and "" or ""
  end
  return vim.bo[buf].modified and "" or ""
end

-- Loading tables, and letting handlers deal with categories
return {
  "tabby.nvim",
  for_cat = {
    cat = "ui",
    default = true,
  },
  event = { "DeferredUIEnter" },
  cmd = { "Tabby" },
  after = function(plugin)
    -- Theme for the tabby config, so we use lualine highlights
    local get_hl = require("tabby.module.highlight").extract
    local theme = {
      fill = get_hl("lualine_c_normal"), -- tabline background
      head = get_hl("lualine_b_normal"), -- head element highlight
      current_tab = get_hl("lualine_a_normal"), -- current tab label highlight
      tab = get_hl("lualine_b_normal"), -- other tab label highlight
      win = get_hl("lualine_b_normal"), -- window highlight
      tail = get_hl("lualine_b_normal"), -- tail element highlight
    }

    require("tabby.tabline").set(function(line)
      return {
        -- Icon menu
        {
          {
            { -- Nix icon for when we are in nixcats
              (require("nixCatsUtils").isNixCats and " 󱄅 " or "  "),
              hl = { fg = "#5277C3", bg = theme.head.bg },
            },
            hl = theme.head,
          },
          line.sep("", theme.head, theme.fill),
        },
        -- List of tabs, main left side
        line.tabs().foreach(function(tab)
          local this_hl = tab.is_current() and theme.current_tab or theme.tab

          -- indicate if any of the buffers in tab have unsaved changes
          local modified = false
          local win_ids = require("tabby.module.api").get_tab_wins(tab.id)
          for _, win_id in ipairs(win_ids) do
            if pcall(vim.api.nvim_win_get_buf, win_id) then
              local bufid = vim.api.nvim_win_get_buf(win_id)
              if vim.api.nvim_get_option_value("modified", { buf = bufid }) then
                modified = true
                break
              end
            end
          end
          return {
            line.sep("", this_hl, theme.fill),
            tab.is_current() and " " or " ",
            tab.number(),
            tab.name(),
            modified and " ",
            -- tab.close_btn(''),
            line.sep(" ", this_hl, theme.fill),
            hl = this_hl,
            margin = " ",
          }
        end),
        line.spacer(),

        -- List of open windows
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          return {
            line.sep("", theme.win, theme.fill),
            win.file_icon(),
            win.buf_name(),
            lsp_diag(win.buf().id),
            line.sep("", theme.win, theme.fill),
            hl = theme.win,
            margin = " ",
          }
        end),
        {
          line.sep("", theme.tail, theme.fill),
          { "  ", hl = theme.tail },
        },
        hl = theme.fill,
      }
    end)
  end,
}
