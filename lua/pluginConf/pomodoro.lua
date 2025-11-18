-- <nixCats>/lua/pluginConf/pomodoro.lua
-- Pomodoro timer

return {
  "pomo.nvim",
  for_cat = {
    cat = "util",
    default = true,
  },
  cmd = {
    "TimerStart",
    "TimerRepeat",
    "TimerSession",
  },
  after = function(plugin)
    require("pomo").setup({
      notifiers = {
        { -- Libnotify notifier
          name = "System",
        },
      },
      -- Specific timer name overrides to notifiers
      timers = {
        -- This makes Break timers to only use the system notifier
        -- Break = { name = "System" },
        -- ["Short Break"] = { name = "System" },
        -- ["Long Break"] = { name = "System" },
      },
      -- Custom timer sessions
      sessions = {
        pomodoro = {
          { name = "Work", duration = "25m" },
          { name = "Short Break", duration = "5m" },
          { name = "Work", duration = "25m" },
          { name = "Short Break", duration = "5m" },
          { name = "Work", duration = "25m" },
          { name = "Long Break", duration = "15m" },
        },
      },
    })
  end,
}
