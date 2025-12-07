-- Debug keymaps following LazyVim conventions
-- https://www.lazyvim.org/extras/dap/core

local map = vim.keymap.set

-- Only set up debug keymaps if DAP is available
if require("nixCatsUtils").enableForCategory("debug") then
  -- DAP keymaps following LazyVim conventions
  local dap_keymap = require("lzextras").keymap("nvim-dap")

  -- Basic DAP controls
  dap_keymap.set("n", "<leader>db", function()
    require("dap").toggle_breakpoint()
  end, { desc = "Toggle Breakpoint" })

  dap_keymap.set("n", "<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "Breakpoint Condition" })

  dap_keymap.set("n", "<leader>dc", function()
    require("dap").continue()
  end, { desc = "Continue" })

  dap_keymap.set("n", "<leader>dC", function()
    require("dap").run_to_cursor()
  end, { desc = "Run to Cursor" })

  dap_keymap.set("n", "<leader>dg", function()
    require("dap").goto_()
  end, { desc = "Go to Line (No Execute)" })

  dap_keymap.set("n", "<leader>di", function()
    require("dap").step_into()
  end, { desc = "Step Into" })

  dap_keymap.set("n", "<leader>dj", function()
    require("dap").down()
  end, { desc = "Down" })

  dap_keymap.set("n", "<leader>dk", function()
    require("dap").up()
  end, { desc = "Up" })

  dap_keymap.set("n", "<leader>dl", function()
    require("dap").run_last()
  end, { desc = "Run Last" })

  dap_keymap.set("n", "<leader>do", function()
    require("dap").step_out()
  end, { desc = "Step Out" })

  dap_keymap.set("n", "<leader>dO", function()
    require("dap").step_over()
  end, { desc = "Step Over" })

  dap_keymap.set("n", "<leader>dp", function()
    require("dap").pause()
  end, { desc = "Pause" })

  dap_keymap.set("n", "<leader>dr", function()
    require("dap").repl.toggle()
  end, { desc = "Toggle REPL" })

  dap_keymap.set("n", "<leader>ds", function()
    require("dap").session()
  end, { desc = "Session" })

  dap_keymap.set("n", "<leader>dt", function()
    require("dap").terminate()
  end, { desc = "Terminate" })

  -- nvim-dap-view mappings
  dap_keymap.set("n", "<leader>du", function()
    require("dap-view").toggle({})
  end, { desc = "Dap View" })

  dap_keymap.set({ "n", "v" }, "<leader>dw", function()
    require("dap-view").add_expr()
  end, { desc = "Add to watch" })

  -- Function key mappings (following your existing conventions)
  dap_keymap.set("n", "<F5>", function()
    require("dap").continue()
  end, { desc = "Debug: Start/Continue" })
  dap_keymap.set("n", "<S-F5>", function()
    require("dap").terminate()
  end, { desc = "Debug: Stop" })
  dap_keymap.set("n", "<F9>", function()
    require("dap").toggle_breakpoint()
  end, { desc = "Debug: Toggle Breakpoint" })
  dap_keymap.set("n", "<F10>", function()
    require("dap").step_over()
  end, { desc = "Debug: Step Over" })
  dap_keymap.set("n", "<F11>", function()
    require("dap").step_into()
  end, { desc = "Debug: Step Into" })
  dap_keymap.set("n", "<S-F11>", function()
    require("dap").step_out()
  end, { desc = "Debug: Step Out" })

  map("n", "<leader>ups", function()
    vim.cmd([[
      :profile start /tmp/nvim-profile.log
      :profile func *
      :profile file *
    ]])
  end, { desc = "Profile Start" })

  map("n", "<leader>upe", function()
    vim.cmd([[
      :profile stop
      :e /tmp/nvim-profile.log
    ]])
  end, { desc = "Profile End" })
end
