local function setup_default()
  local ergoterm = require("ergoterm")

  return ergoterm:new({
    name = "default",
    sticky = true,
  })
end

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

  map("n", "<C-a>", function()
    claude:toggle()
  end, { desc = "Toggle Claude" })
  map("t", "<C-a>", function()
    claude:toggle()
  end, { desc = "Toggle Claude" })
end

local function setup_lazygit()
  local ergoterm = require("ergoterm")
  local lazyterm = ergoterm.with_defaults({
    cmd = "lazygit",
    name = "lazygit",
    layout = "float",
    sticky = true,
    auto_list = false,
    bang_target = false,
  })
  local lazygit = lazyterm:new()

  vim.keymap.set("n", "<leader>gg", function()
    lazygit:toggle()
  end, { noremap = true, silent = true, desc = "LazyGit" })
  vim.keymap.set("n", "<leader>gf", function()
    lazyterm
      :new({
        name = "lazylog",
        cmd = "lazygit log -f " .. vim.fn.expand("%"),
        sticky = false,
      })
      :focus()
  end, { desc = "LazyGit Current File History" })
  vim.keymap.set("n", "<leader>gl", function()
    lazyterm
      :new({
        name = "lazylog",
        cmd = "lazygit log",
        sticky = false,
      })
      :focus()
  end, { desc = "LazyGit log" })
end

local function setup_tasks()
  local ergoterm = require("ergoterm")

  local task = ergoterm.with_defaults({
    tags = { "task" },
    auto_list = false,
    bang_target = false,
    sticky = true,
    auto_scroll = true,
    default_action = function(term)
      term:open()
    end,
  })

  task:new({
    name = "dev up",
    on_start = function(term)
      term:send({ "dev up" })
    end,
    show_on_success = true,
  })
  task:new({
    name = "gt sync",
    cmd = "gt sync",
  })
  task:new({
    name = "gt modify",
    cmd = "gt modify -a",
  })
  task:new({
    name = "gt submit --stack",
    cmd = "gt ss",
  })
  task:new({
    name = "gt up",
    cmd = "gt up",
  })
  task:new({
    name = "gt down",
    cmd = "gt down",
  })
  task:new({
    name = "gt split",
    cmd = "gt split",
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
    cat = "util",
    default = true,
  },
  lazy = false,
  after = function(plugin)
    require("ergoterm").setup({
      terminal_defaults = {
        layout = "below",
        size = {
          below = "30%",
          right = "36%",
        },
      },
    })
    setup_claude()
    setup_lazygit()
    setup_tasks()
    local default = setup_default()
    if default then
      default:start()
    end
  end,
}
