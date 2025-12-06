local function setup_claude()
  local ergoterm = require("ergoterm")
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }
  local claude = ergoterm:new({
    cmd = "claude",
    name = "claude",
    layout = "right",
    auto_list = false,
    bang_target = false,
    sticky = true,
    watch_files = true,
  })
  -- Toggle Claude terminal
  map("n", "<leader>ai", function()
    claude:toggle()
  end, { desc = "Toggle Claude" })

  -- Reference current file to Claude
  map("n", "<leader>aa", function()
    local file = vim.fn.expand("%:p")
    claude:send({ "@" .. file .. " " }, { new_line = false })
  end, opts)

  -- Send current line to Claude
  map("n", "<leader>as", function()
    claude:send("single_line")
  end, opts)

  -- Send visual selection to Claude
  map("v", "<leader>as", function()
    claude:send("visual_selection", { trim = false })
  end, opts)
end

return {
  "ergoterm-nvim",
  for_cat = {
    cat = "coding",
    default = true,
  },
  lazy = false,
  after = function(plugin)
    setup_claude()
    require("ergoterm").setup()
  end,
}
