local function setup_default()
  local ergoterm = require("ergoterm")

  return ergoterm:new({
    name = "default",
    sticky = true,
  })
end

local function setup_ai()
  local ergoterm = require("ergoterm")
  local map = vim.keymap.set

  local ai_chats = ergoterm.with_defaults({
    layout = "right",
    auto_list = false,
    bang_target = false,
    sticky = true,
    watch_files = true,
    tags = { "ai_chat" },
  })

  -- Create instances for different AI tools
  ai_chats:new({
    cmd = "claude",
    name = "claude",
    meta = {
      add_line = function(term)
        return term:send("single_line")
      end,
      add_selection = function(term)
        return term:send("visual_selection", { trim = false })
      end,
    },
  })

  local opencode = ai_chats:new({
    cmd = "opencode",
    name = "opencode",
    env = {
      OPENAI_API_KEY = vim.env.OPENAI_API_KEY or "",
    },
    meta = {
      add_line = function(term)
        return term:send({ "@this " .. "_" })
      end,
      add_selection = function(term)
        return term:send({ "@this" })
      end,
    },
  })

  local chats = ergoterm.filter_by_tag("ai_chat")

  map("n", "<leader>al", function()
    ergoterm.select({
      terminals = chats,
      prompt = "Select AI assistant",
    })
  end, { desc = "List AI Chats" })

  -- Send line: shortcuts to Opencode if it's the only one running,
  -- otherwise shows picker
  map("n", "<leader>as", function()
    ergoterm.select_started({
      terminals = chats,
      prompt = "Send to assistant",
      callbacks = function(term)
        return term.meta.add_line(term)
      end,
      default = opencode,
    })
  end, { noremap = true, silent = true, desc = "Send Line to assistant" })

  -- Send selection: same smart behavior for visual mode
  map("v", "<leader>as", function()
    ergoterm.select_started({
      terminals = chats,
      prompt = "Send to chat",
      callbacks = function(term)
        return term.meta.add_selection(term)
      end,
      default = opencode,
    })
  end, { noremap = true, silent = true, desc = "Send Selection to assistant" })

  map({ "n", "x" }, "<leader>aa", function()
    require("opencode").ask("@this: ", { submit = true })
  end, { desc = "Ask opencode" })
  map({ "n", "x" }, "<leader>ax", function()
    require("opencode").select()
  end, { desc = "Execute opencode action…" })
  map({ "n", "t" }, "<C-a>", function()
    opencode:toggle()
  end, { desc = "Toggle opencode" })
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
    on_open = function(term)
      -- Remap q to hide instead of quit (lazygit startup can be slow in large repos)
      vim.keymap.set("t", "q", function()
        term:close()
      end, { buffer = term:get_state("bufnr"), desc = "Hide lazygit" })
    end,
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

local function load_tasks_from_file(filepath)
  local f = loadfile(filepath)
  if f then
    local ok, tasks = pcall(f)
    if ok and type(tasks) == "table" then
      return tasks
    end
  end
  return {}
end

--- Group tasks by their `group` field
--- Tasks without a group are placed in "other"
---@param tasks table[] Array of terminal instances
---@return table<string, table[]> Map of group name to array of terminals
local function group_tasks_by_cli(tasks)
  local groups = {}
  for _, term in ipairs(tasks) do
    -- Get the group from term.meta.group (meta is stored directly on terminal, not in state)
    local meta = term.meta or {}
    local group_name = meta.group or "other"
    if not groups[group_name] then
      groups[group_name] = {}
    end
    table.insert(groups[group_name], term)
  end
  return groups
end

--- Get sorted group names (alphabetically, but "other" always last)
---@param groups table<string, table[]>
---@return string[]
local function get_sorted_group_names(groups)
  local names = {}
  for name, _ in pairs(groups) do
    if name ~= "other" then
      table.insert(names, name)
    end
  end
  table.sort(names)
  -- Add "other" at the end if it exists
  if groups["other"] then
    table.insert(names, "other")
  end
  return names
end

--- Show a picker to select a task group, then show tasks in that group
---@param ergoterm table The ergoterm module
---@param task_list table[] Array of terminal instances
local function select_task_by_group(ergoterm, task_list)
  local groups = group_tasks_by_cli(task_list)
  local group_names = get_sorted_group_names(groups)

  -- If only one group (or no groups), skip group selection
  if #group_names <= 1 then
    ergoterm.select({
      terminals = task_list,
      prompt = "Run task",
    })
    return
  end

  local show_group_picker, show_tasks_for_group

  function show_tasks_for_group(group_name)
    local tasks = groups[group_name]
    local task_names = {}
    for _, term in ipairs(tasks) do
      table.insert(task_names, term.name or "unnamed")
    end
    table.insert(task_names, "← Back")

    vim.ui.select(task_names, {
      prompt = "Run " .. group_name .. " task:",
    }, function(choice)
      if choice == "← Back" then
        show_group_picker()
      elseif choice then
        -- Find and run the selected task
        for _, term in ipairs(tasks) do
          if (term.name or "unnamed") == choice then
            term:default_action()
            break
          end
        end
      end
    end)
  end

  function show_group_picker()
    -- Use vim.ui.select for consistent styling with ergoterm's task selector
    vim.ui.select(group_names, {
      prompt = "Select task group:",
      format_item = function(name)
        local tasks = groups[name]
        local task_names = {}
        local max_preview = 2
        for i, term in ipairs(tasks) do
          if i > max_preview then
            break
          end
          table.insert(task_names, term.name or "unnamed")
        end
        local preview = table.concat(task_names, ", ")
        if #tasks > max_preview then
          preview = preview .. " and " .. (#tasks - max_preview) .. " more"
        end
        return string.format("%s (%s)", name, preview)
      end,
    }, function(choice)
      if choice then
        show_tasks_for_group(choice)
      end
    end)
  end

  show_group_picker()
end

--- Show all tasks in a single flat picker (for quick access)
---@param ergoterm table The ergoterm module
---@param task_list table[] Array of terminal instances
local function select_all_tasks(ergoterm, task_list)
  ergoterm.select({
    terminals = task_list,
    prompt = "Run task",
  })
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

  -- Load user-wide tasks from XDG config
  local user_tasks_path = vim.fn.stdpath("config") .. "/tasks.lua"
  local user_tasks = load_tasks_from_file(user_tasks_path)
  for _, t in ipairs(user_tasks) do
    t.tags = t.tags or { "task" }
    -- Store the group in meta for later retrieval
    t.meta = t.meta or {}
    t.meta.group = t.group
    task:new(t)
  end

  -- Load project-local tasks (overrides/adds to user tasks)
  local project_tasks_path = vim.fn.getcwd() .. "/.nvim/tasks.lua"
  local project_tasks = load_tasks_from_file(project_tasks_path)
  for _, t in ipairs(project_tasks) do
    t.tags = t.tags or { "task" }
    -- Store the group in meta for later retrieval
    t.meta = t.meta or {}
    t.meta.group = t.group
    task:new(t)
  end

  local task_list = ergoterm.filter_by_tag("task")

  -- <leader>k - Two-stage picker: select group first, then task
  vim.keymap.set("n", "<leader>k", function()
    select_task_by_group(ergoterm, task_list)
  end, { noremap = true, silent = true, desc = "Run task (by group)" })

  -- <leader>K - All tasks in a flat list (quick access, no grouping)
  vim.keymap.set("n", "<leader>K", function()
    select_all_tasks(ergoterm, task_list)
  end, { noremap = true, silent = true, desc = "Run task (all)" })
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
        start_in_insert = false,
        on_open = function(term)
          -- Prevent other plugins (like nvim-dap) from hijacking terminal windows
          -- to display files. winfixbuf tells Neovim this window should only show
          -- its current buffer.
          local winid = term:get_state("window")
          if winid and vim.api.nvim_win_is_valid(winid) then
            vim.api.nvim_set_option_value("winfixbuf", true, { win = winid })
          end
        end,
      },
    })
    setup_ai()
    setup_lazygit()
    setup_tasks()
    local default = setup_default()
    if default then
      default:start()
    end
  end,
}
