return {
  "shadowenv-vim",
  for_cat = {
    cat = "lsp",
    default = true,
  },
  lazy = false,
  after = function(plugin)
    -- ============================================================================
    -- Ruby Shadowenv LSP Integration
    -- ============================================================================
    -- Integrates Ruby LSP with shadowenv to support multiple projects with
    -- different Ruby environments in a single Neovim session.
    --
    -- Prerequisites:
    -- - shadowenv.vim plugin (provides ShadowenvHook command)
    -- - nvim-lspconfig (provides LSP configuration)
    -- - This file should load AFTER both plugins are initialized
    -- ============================================================================

    -- ============================================================================
    -- Shadowenv Module - Handles all shadowenv operations
    -- ============================================================================
    local shadowenv = {}

    -- Check if a directory has shadowenv configuration
    shadowenv.has_shadowenv = function(dir)
      return vim.fn.isdirectory(dir .. "/.shadowenv.d") == 1
    end

    -- Load shadowenv environment for a directory
    shadowenv.load_environment = function(directory)
      if not shadowenv.has_shadowenv(directory) then
        return nil
      end

      local original_cwd = vim.fn.getcwd()

      -- Change to directory and load shadowenv
      vim.cmd("cd " .. vim.fn.fnameescape(directory))
      local ok, _ = pcall(function()
        vim.cmd("ShadowenvHook")
      end)

      if not ok then
        vim.cmd("cd " .. vim.fn.fnameescape(original_cwd))
        return nil
      end

      -- Capture environment
      local env = vim.fn.environ()

      -- Restore directory
      vim.cmd("cd " .. vim.fn.fnameescape(original_cwd))

      return env
    end

    -- Extract Ruby-specific paths from shadowenv environment
    shadowenv.get_ruby_paths = function(environment)
      if not environment or not environment.GEM_PATH then
        return nil
      end

      local gem_path = environment.GEM_PATH
      local shadowenv_gem_dir = gem_path:match("(/[^:]*%.dev/gem/[^:]+)")

      if shadowenv_gem_dir then
        return {
          ruby_lsp = shadowenv_gem_dir .. "/bin/ruby-lsp",
          gem_home = shadowenv_gem_dir,
          gem_path = gem_path,
          bundle_app_config = shadowenv_gem_dir,
          path = environment.PATH,
        }
      end

      return nil
    end

    -- ============================================================================
    -- LSP Module - Handles all LSP operations
    -- ============================================================================
    local lsp = {}

    -- Create capabilities for LSP
    lsp.make_capabilities = function()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        return cmp_nvim_lsp.default_capabilities()
      else
        return vim.lsp.protocol.make_client_capabilities()
      end
    end

    -- Create and start an LSP client
    lsp.create_client = function(config)
      return vim.lsp.start(config, {
        bufnr = config.bufnr,
        reuse_client = function(_, _)
          return false
        end,
      })
    end

    -- Attach existing client to buffer
    lsp.attach_client = function(client_id, bufnr)
      local client = vim.lsp.get_client_by_id(client_id)
      if client and client.initialized then
        vim.lsp.buf_attach_client(bufnr, client_id)
        return true
      end
      return false
    end

    -- Stop an LSP client
    lsp.stop_client = function(client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      if client then
        client:stop()
      end
    end

    -- Check if client is active
    lsp.is_client_active = function(client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      return client and client.initialized
    end

    -- ============================================================================
    -- Ruby Project Module - Business logic for Ruby projects
    -- ============================================================================
    local ruby_project = {}

    -- State tracking
    ruby_project.state = {
      projects = {}, -- project_root -> { client_id, env_type }
      buffers = {}, -- buffer_number -> project_root
    }

    -- Find Ruby project root from a file path
    ruby_project.find_root = function(filepath)
      local dir = vim.fn.fnamemodify(filepath, ":p:h")

      while dir ~= "/" do
        -- Check for Ruby project markers
        if
          vim.fn.filereadable(dir .. "/Gemfile") == 1
          or vim.fn.filereadable(dir .. "/.ruby-version") == 1
          or vim.fn.filereadable(dir .. "/config.ru") == 1
          or shadowenv.has_shadowenv(dir)
        then
          return dir
        end
        dir = vim.fn.fnamemodify(dir, ":h")
      end

      return nil
    end

    -- Build LSP configuration for a Ruby project
    ruby_project.build_lsp_config = function(project_root, bufnr)
      local config = {
        name = "ruby_lsp_" .. project_root:gsub("[/\\]", "_"),
        cmd = { "ruby-lsp" },
        root_dir = project_root,
        bufnr = bufnr,
        capabilities = lsp.make_capabilities(),
        init_options = {
          formatter = "auto",
          experimentalFeaturesEnabled = true,
        },
        on_attach = function(_, attached_bufnr)
          -- Ruby-specific keybindings
          vim.keymap.set("n", "<leader>pr", function()
            vim.lsp.buf_request(attached_bufnr, "workspace/executeCommand", {
              command = "rubyLsp/showRailsRoutes",
              arguments = {},
            })
          end, { buffer = attached_bufnr, desc = "Project routes (Rails)" })
        end,
      }

      -- Try to load shadowenv
      local env_type = "system"
      local environment = shadowenv.load_environment(project_root)

      if environment then
        local ruby_paths = shadowenv.get_ruby_paths(environment)
        if ruby_paths then
          config.cmd = { ruby_paths.ruby_lsp }
          config.cmd_env = {
            GEM_HOME = ruby_paths.gem_home,
            GEM_PATH = ruby_paths.gem_path,
            BUNDLE_APP_CONFIG = ruby_paths.bundle_app_config,
            PATH = ruby_paths.path,
          }
          env_type = "shadowenv"
        end
      end

      return config, env_type
    end

    -- Ensure a project has an LSP client
    ruby_project.ensure_lsp = function(project_root, bufnr)
      local project = ruby_project.state.projects[project_root]

      -- Try to reuse existing client
      if project and lsp.is_client_active(project.client_id) then
        if lsp.attach_client(project.client_id, bufnr) then
          return
        end
      end

      -- Create new client
      local config, env_type = ruby_project.build_lsp_config(project_root, bufnr)
      local client_id = lsp.create_client(config)

      if client_id then
        ruby_project.state.projects[project_root] = {
          client_id = client_id,
          env_type = env_type,
        }
      end
    end

    -- Clean up unused projects
    ruby_project.cleanup = function()
      local active_projects = {}
      for _, project_root in pairs(ruby_project.state.buffers) do
        active_projects[project_root] = true
      end

      for project_root, project in pairs(ruby_project.state.projects) do
        if not active_projects[project_root] then
          lsp.stop_client(project.client_id)
          ruby_project.state.projects[project_root] = nil
        end
      end
    end

    -- Handle Ruby files
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      pattern = { "*.rb", "*.rake", "Gemfile", "Rakefile", "*.gemspec" },
      callback = function(args)
        local filepath = args.file
        if not filepath or filepath == "" then
          return
        end

        local project_root = ruby_project.find_root(filepath)
        if project_root then
          ruby_project.state.buffers[args.buf] = project_root
          ruby_project.ensure_lsp(project_root, args.buf)
        end
      end,
      group = vim.api.nvim_create_augroup("ruby_shadowenv_lsp", { clear = true }),
      desc = "Setup Ruby LSP with shadowenv support",
    })

    -- Cleanup when buffers close
    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function(args)
        ruby_project.state.buffers[args.buf] = nil
        vim.defer_fn(ruby_project.cleanup, 1000)
      end,
      group = vim.api.nvim_create_augroup("ruby_shadowenv_lsp_cleanup", { clear = true }),
      desc = "Cleanup unused Ruby LSP instances",
    })

    -- Status command
    vim.api.nvim_create_user_command("RubyShadowenvStatus", function()
      local lines = { "Ruby Shadowenv LSP Status:", "" }

      for root, project in pairs(ruby_project.state.projects) do
        local active = lsp.is_client_active(project.client_id)

        table.insert(lines, string.format("• %s", vim.fn.fnamemodify(root, ":~")))
        table.insert(lines, string.format("  Status: %s", active and "active" or "inactive"))
        table.insert(lines, string.format("  Environment: %s", project.env_type))
      end

      if vim.tbl_isempty(ruby_project.state.projects) then
        table.insert(lines, "No active Ruby projects")
      end

      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Ruby Shadowenv" })
    end, { desc = "Show Ruby shadowenv LSP status" })
  end,
}
