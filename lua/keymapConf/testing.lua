if require("nixCatsUtils").enableForCategory("testing") then
  local neotest_keymap = require("lzextras").keymap("neotest")

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
