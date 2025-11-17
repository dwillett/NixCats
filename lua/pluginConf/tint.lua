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
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufid })
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

        -- Do not tint `terminal` or floating windows, tint everything else
        return buftype == "terminal" or floating
      end,
    })
  end,
}
