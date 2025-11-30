return {
  {
    "FixCursorHold.nvim",
    for_cat = {
      cat = "testing",
      default = true,
    },
    lazy = false,
  },
  {
    "neotest",
    for_cat = {
      cat = "testing",
      default = true,
    },
    on_require = { "neotest" },
    on_plugin = { "nvim-treesitter" }, -- Ensure treesitter loads first
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("neotest-plenary")
      vim.cmd.packadd("neotest-minitest")
      vim.cmd.packadd("neotest-rspec")
    end,
    event = "BufAdd */*test*/",
    after = function(plugin)
      -- WORKAROUND: nixCats packages treesitter grammars separately from nvim-treesitter
      -- Neotest's subprocess doesn't include these grammar paths by default, causing
      -- "No parser for language X" errors. This fix adds grammar paths to the subprocess.

      -- Collect all paths that contain parser directories
      local grammar_paths = {}
      for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
        if vim.fn.isdirectory(path .. "/parser") == 1 then
          table.insert(grammar_paths, path)
        end
      end

      -- Hook into neotest.lib.subprocess to add grammar paths
      local ok, subprocess = pcall(require, "neotest.lib.subprocess")
      if ok and subprocess.add_to_rtp then
        -- Hook add_to_rtp to ensure grammar paths are included
        local original_add_to_rtp = subprocess.add_to_rtp
        subprocess.add_to_rtp = function(to_add)
          -- Call original function first
          original_add_to_rtp(to_add)

          -- Add our grammar paths directly to the subprocess
          local nio = require("nio")

          -- Access the child channel through debug.getupvalue
          -- (it's a local variable in the subprocess module)
          local chan = nil
          for i = 1, 20 do
            local name, value = debug.getupvalue(original_add_to_rtp, i)
            if not name then
              break
            end
            if name == "child_chan" then
              chan = value
              break
            end
          end

          if chan and #grammar_paths > 0 then
            -- Get current rtp from subprocess
            local success, current_rtp = pcall(nio.fn.rpcrequest, chan, "nvim_get_option_value", "runtimepath", {})
            if success then
              -- Add grammar paths if not already present
              local modified = false
              for _, gpath in ipairs(grammar_paths) do
                if not string.find(current_rtp, gpath, 1, true) then
                  current_rtp = current_rtp .. "," .. gpath
                  modified = true
                end
              end

              -- Set the modified runtimepath
              if modified then
                pcall(nio.fn.rpcrequest, chan, "nvim_set_option_value", "runtimepath", current_rtp, {})
              end
            end
          end
        end
      end

      require("neotest").setup({
        adapters = {
          require("neotest-minitest"),
          require("neotest-rspec"),
        },
        icons = {
          passed = "✓",
          running = "⟳",
          failed = "✗",
          skipped = "○",
          unknown = "?",
        },
        diagnostic = {
          enabled = false,
        },
        discovery = {
          enabled = false,
        },
        floating = {
          border = "rounded",
          max_height = 0.8,
          max_width = 0.8,
          options = {},
        },
        status = {
          enabled = true,
          virtual_text = false,
          signs = false,
        },
        output = {
          enabled = true,
          open_on_run = true,
        },
        output_panel = {
          enabled = true,
        },
        quickfix = {
          open = function()
            local ok, trouble = pcall(require, "trouble")
            if ok then
              trouble.open({ mode = "quickfix", focus = false })
            else
              vim.cmd("copen")
            end
          end,
        },
      })
      vim.fn.sign_unplace("neotest")
    end,
  },
}
