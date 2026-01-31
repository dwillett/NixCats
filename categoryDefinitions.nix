# The category definitions
# Import inputs from the main flake, and return the function
{...}: {pkgs, ...}: {
  # <category>
  # ├─ coding
  # ├─ debug
  # ├─ editor
  # ├─ formatting
  # ├─ lsp
  # ├─ markdown
  # ├─ testing
  # ├─ treesitter
  # ├─ ui
  # └─ util
  # This is LSPs and system-wide tooling
  lspsAndRuntimeDeps = with pkgs; {
    formatting = [
      alejandra
      stylua
      selene
      nix-doc
      dotenv-linter
    ];
    lsp = [
      clang-tools
      lua-language-server
      glow
      languagetool
      nixd
      ruff
      ruby-lsp
      shadowenv
      nodePackages.typescript-language-server
    ];
    util = [
      bash
      dash
      git
      lazygit
      ripgrep
      fd
      findutils
      xclip
      universal-ctags
    ];
    ui = [
      imagemagick
    ];
  };

  # Plugins that don't need lazy loading
  startupPlugins = with pkgs.vimPlugins; {
    # Main plugins to have
    editor = [
      pkgs.neovimPlugins.canopy-nvim
      pkgs.neovimPlugins.canopy-git-nvim
      pkgs.neovimPlugins.canopy-graphite-nvim
    ];
    lsp = [
      pkgs.neovimPlugins.shadowenv-vim
    ];
    testing = [
      FixCursorHold-nvim
    ];
    treesitter = [
      nvim-treesitter.withAllGrammars
    ];
    util = [
      pkgs.neovimPlugins.ergoterm-nvim
      lze
      lzextras
      oil-nvim
      opencode-nvim
      snacks-nvim
    ];
    ui = [
      nui-nvim
      noice-nvim
      nvim-web-devicons
    ];
  };

  # Lazy loading plugins
  optionalPlugins = with pkgs.vimPlugins; {
    coding = [
      blink-cmp
      blink-copilot
      blink-ripgrep-nvim
      blink-emoji-nvim
      luasnip
      friendly-snippets
    ];
    debug = [
      nvim-nio
      nvim-dap
      pkgs.neovimPlugins.nvim-dap-ruby
      nvim-dap-view
      nvim-dap-virtual-text
    ];
    editor = [
      mini-nvim
      flash-nvim
      grug-far-nvim
      which-key-nvim
      gitsigns-nvim
      neogit
      diffview-nvim
      trouble-nvim
      treesj
    ];
    formatting = [
      conform-nvim
      nvim-lint
    ];
    lsp = [
      copilot-lsp
      copilot-lua
      lazydev-nvim
      nvim-lspconfig
    ];
    markdown = [
      mkdnflow-nvim
      glow-nvim
      render-markdown-nvim
    ];
    testing = [
      neotest
      pkgs.neovimPlugins.neotest-ruby-minitest
      neotest-plenary
      neotest-rspec
      pkgs.neovimPlugins.neotest-busted
    ];
    treesitter = [
      nvim-treesitter-context
      pkgs.neovimPlugins.nvim-treesitter-textobjects
    ];
    ui = [
      catppuccin-nvim
      cyberdream-nvim
      gruvbox-nvim
      gruvbox-material-nvim
      kanagawa-nvim
      melange-nvim
      nightfox-nvim
      onedark-nvim
      {
        name = "lualine.nvim";
        plugin = pkgs.neovimPlugins.lualine-nvim;
      }
      tabby-nvim
      aerial-nvim
      lspkind-nvim
    ];
    util = [
      edgy-nvim
      plenary-nvim
      urlview-nvim
      pomo-nvim
    ];
  };

  # shared libraries to be added to LD_LIBRARY_PATH
  # variable available to nvim runtime
  sharedLibraries = with pkgs; {
    util = [
      libgit2
      libnotify
    ];
  };

  environmentVariables = {
  };

  extraWrapperArgs = {
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  };

  # lists of the functions you would have passed to
  # python.withPackages or lua.withPackages
  python3.libraries = {
    util = python-pkgs:
      with python-pkgs; [
        pynvim # Python client for neovim
      ];
    markdown = python-pkgs:
      with python-pkgs; [
        mdformat # Markdown formatter
        pylatexenc # Latex to unicode and back conversion
      ];
    lsp = python-pkgs:
      with python-pkgs; [
        ruff # Python linter and code formatter
        uv # Package manager for python
      ];
  };

  # Populates $LUA_PATH and $LUA_CPATH
  extraLuaPackages = {
    util = [
      (lua-pkgs:
        with lua-pkgs; [
          magick
        ])
    ];
    editor = [
      (lua-pkgs:
        with lua-pkgs; [
          jsregexp
        ])
    ];
    formatting = [
      (lua-pkgs:
        with lua-pkgs; [
          luacheck
        ])
    ];
  };

  # Defining language = [ "language" "default"]; in this attrset would
  # cause any import of a subcategory of language to import language.default as well
  extraCats = {
  };
}
