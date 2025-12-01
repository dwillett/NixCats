-- <nixCats>/lua/pluginConf/dap.lua
-- Debug adapter protocol

return {
  {
    "nvim-dap-ruby",
    for_cat = {
      cat = "debug",
      default = true,
    },
    on_plugin = { "nvim-dap" },
    after = function(plugin)
      require("dap-ruby").setup()
    end,
  },
  {
    "nvim-dap",
    for_cat = {
      cat = "debug",
      default = true,
    },
    on_require = { "dap" },
    load = function(name)
      require("lzextras").loaders.multi({
        name,
        "nvim-dap-ui",
        "nvim-dap-virtual-text",
      })
    end,
    after = function(_)
      local dap = require("dap")
      local dapui = require("dapui")

      -- dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      -- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      -- dap.listeners.before.event_exited["dapui_config"] = dapui.close

      dapui.setup({})

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })
    end,
  },
  {
    "nvim-nio",
    for_cat = {
      cat = "debug",
      default = true,
    },
    dep_of = {
      "nvim-dap-ui",
      "neotest",
    },
  },
}
