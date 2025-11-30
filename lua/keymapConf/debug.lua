-- Debug keymaps following LazyVim conventions
-- https://www.lazyvim.org/extras/dap/core

local map = vim.keymap.set

-- Only set up debug keymaps if DAP is available
if require("nixCatsUtils").enableForCategory("debug") then
  -- DAP keymaps following LazyVim conventions
  local dap_keymap = require("lzextras").keymap("nvim-dap")
  local dap_ui_keymap = require("lzextras").keymap("nvim-dap-ui")
  local neotest_keymap = require("lzextras").keymap("neotest")

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

  dap_keymap.set("n", "<leader>dw", function()
    require("dap.ui.widgets").hover()
  end, { desc = "Widgets" })

  -- DAP UI specific keymaps
  if require("nixCatsUtils").enableForCategory("debug") then
    dap_ui_keymap.set("n", "<leader>du", function()
      require("dapui").toggle({})
    end, { desc = "Dap UI" })

    dap_ui_keymap.set("n", "<leader>de", function()
      require("dapui").eval()
    end, { desc = "Eval" })

    dap_ui_keymap.set("v", "<leader>de", function()
      require("dapui").eval()
    end, { desc = "Eval" })
  end

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

  -- Test operations
  neotest_keymap.set("n", "<leader>tc", function()
    require("neotest").run.run()
    require("neotest").output.open({ enter = false }) -- Auto-open output
  end, { desc = "Run Nearest" })

  neotest_keymap.set("n", "<leader>tC", function()
    vim.cmd("noautocmd write")
    require("neotest").run.run({ strategy = "dap" }) -- Auto-open output
  end, { desc = "Debug Nearest" })

  neotest_keymap.set("n", "<leader>tf", function()
    require("neotest").run.run(vim.fn.expand("%"))
  end, { desc = "Run File" })

  neotest_keymap.set("n", "<leader>tT", function()
    require("neotest").run.run(vim.uv.cwd())
  end, { desc = "Run All Test Files" })

  neotest_keymap.set("n", "<leader>ts", function()
    require("neotest").summary.toggle()
  end, { desc = "Toggle Summary" })

  neotest_keymap.set("n", "<leader>to", function()
    require("neotest").output.open({ enter = true, auto_close = true })
  end, { desc = "Show Output" })

  neotest_keymap.set("n", "<leader>tO", function()
    require("neotest").output_panel.toggle()
  end, { desc = "Toggle Output Panel" })

  neotest_keymap.set("n", "<leader>tS", function()
    require("neotest").run.stop()
  end, { desc = "Stop" })

  neotest_keymap.set("n", "<leader>tw", function()
    require("neotest").watch.toggle(vim.fn.expand("%"))
  end, { desc = "Toggle Watch" })
end
