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

local function setup_tasks()
  local ergoterm = require("ergoterm")

  local float = ergoterm.with_defaults({
    layout = "float",
    tags = { "task" },
    auto_list = false,
    bang_target = false,
    sticky = true,
    auto_scroll = true,
    default_action = function(term)
      term:open()
    end,
  })

  local below = ergoterm.with_defaults({
    layout = "float",
    tags = { "task" },
    auto_list = false,
    bang_target = false,
    sticky = true,
    auto_scroll = true,
    default_action = function(term)
      term:open()
    end,
  })

  below:new({
    name = "dev up",
    command = "dev up",
  })
  float:new({
    name = "gt sync",
    command = "gt sync",
  })
  float:new({
    name = "gt modify",
    command = "gt modify -a",
  })
  float:new({
    name = "gt submit --stack",
    command = "gt ss",
  })
  float:new({
    name = "gt up",
    command = "gt up",
  })
  float:new({
    name = "gt down",
    command = "gt down",
  })
  below:new({
    name = "gt split",
    command = "gt split",
  })
  local task_list = ergoterm.filter_by_tag("task")

  vim.keymap.set("n", "<leader>k", function()
    ergoterm.select({
      terminals = task_list,
      prompt = "Run task",
    })
  end, { noremap = true, silent = true, desc = "Run task" })
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
    setup_tasks()
    require("ergoterm").setup({})
  end,
}
