return {
  "tint.nvim",
  for_cat = {
    cat = "ui",
    default = true,
  },
  event = { "DeferredUIEnter" },
  on_require = { "tint" },
  after = function(plugin)
    require("tint").setup({
      highlight_ignore_patterns = {
        "WinSeparator",
        "Status.*",
        "VertSplit",
        "LineNr",
      }, -- Highlight group patterns to ignore, see `string.find`
      window_ignore_function = function(winid)
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

        -- Do not tint floating windows, tint everything else
        return floating
      end,
    })
  end,
}
