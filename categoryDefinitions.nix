# The category definitions
# Import inputs from the main flake, and return the function
{inputs, ...}: {
  pkgs,
  settings,
  categories,
  extra,
  name,
  mkNvimPlugin,
  ...
} @ packageDef:
{
  # The way the tree is established is;
  # <category>
  # ├─ system         : Plugins that should be there by default
  # ├─ tools          : Functionality that is language agnostic
  # │  ├─ completion  : Code completion
  # │  ├─ debug       : Debug related tooling
  # │  ├─ files       : File browser
  # │  ├─ formatting  : Linting and spelling
  # │  ├─ git         : Git integration
  # │  ├─ motions     : Movement related plugins
  # │  ├─ search      : Pickers functionality
  # │  ├─ snippets    : Snippet engine
  # │  ├─ treesitter  : Code parsing
  # │  └─ utility     : Small functionalities
  # ├─ ui             : Viewing related plugins
  # │  ├─ bar         : Status bar items
  # │  ├─ theme       : Colorscheme and theme
  # │  ├─ views       : Screens for viewing code status
  # │  └─ icons       : Icon usage
  # └─ languages      : Configured languages
  #    ├─ c
  #    ├─ latex
  #    ├─ lua
  #    ├─ markdown
  #    ├─ nix
  #    ├─ python
  #    ├─ shell
  #    └─ typescript

  # System level requirements
  # These packages should be available to the nixCat instance
  # Similar to programs.neovim.extraPackages in homeManager
  # This is LSPs and system-wide tooling
  lspsAndRuntimeDeps = with pkgs; {
    tools = {
      files = [
        imagemagick # For image displaying with image.nvim and snacks.image
      ];
      treesitter = [
        tree-sitter
      ];
      git = [
        git
        lazygit
      ];
      search = [
        ripgrep # Fast grep implementation
        fd # Fast find implementation
        findutils # Find implementation
      ];
      utility = [
        xclip # Xorg clipboard communication
        universal-ctags # Tag generation for multiple languages
      ];
    };

    ui = {
      views = [
        dwt1-shell-color-scripts # For terminal color scripts
      ];
    };

    languages = {
      c = [
        clang-tools
      ];
      lua = [
        lua-language-server
        stylua
      ];
      markdown = [
        glow # Markdown typesetter for terminal
        languagetool
      ];
      nix = [
        nix-doc
        nixd
        alejandra
      ];
      python = [
        ruff
      ];
      shell = [
        bash
        dash
        dotenv-linter
      ];
      typescript = [
        nodePackages.typescript-language-server
      ];
    };
  };

  # Plugins that don't need lazy loading
  startupPlugins = with pkgs.vimPlugins; {
    # Main plugins to have
    system = [
      lze # Lazy loader for plugins (NEEDED)
      lzextras # Lazy loader extras
    ];

    tools = {
      files = [
      snacks-nvim
        oil-nvim # File browser
      ];
    };

    ui = {
      theme = [
        nvim-web-devicons
      ];
    };

    languages = {};
  };

  # Lazy loading plugins
  optionalPlugins = with pkgs.vimPlugins; {
    system = [
      plenary-nvim # Library for other plugins
      nui-nvim
      mini-base16 # Request the minimal theme
    ];

    tools = {
      # Completion engines
      completion = [
        nvim-lspconfig # LSP default configuration
      ];
      # Debug tools
      debug = [
        nvim-nio # Library for asyncronous IO for nvim
        nvim-dap # Debug adapter protocol for nvim
        nvim-dap-ui # DAP ui
        nvim-dap-virtual-text # DAP virtual text support
      ];
      files = [
        yazi-nvim # File browser
      ];
      formatting = [
        conform-nvim # Code formatter
        nvim-lint # Linter without LSP
      ];
      git = [
        gitsigns-nvim
        vim-fugitive
      ];
      motions = [
        flash-nvim # Movement tool
        mini-nvim # Library for motions
      ];
      search = [
      ];
      snippets = [
        luasnip
        friendly-snippets
      ];
      treesitter = [
        nvim-treesitter.withAllGrammars
        nvim-treesitter-context
        nvim-treesitter-refactor
        nvim-treesitter-textobjects
      ];
      utility = [
        mkdir-nvim # Automatically make directories when saving files
        urlview-nvim # Detects URLs
        pomo-nvim # Pomodoro timer
      ];
    };

    ui = {
      theme = [
        # Themes that may be used
        catppuccin-nvim
        cyberdream-nvim
        gruvbox-nvim
        gruvbox-material-nvim
        kanagawa-nvim
        melange-nvim
        nightfox-nvim
        onedark-nvim
      ];
      bar = [
        lualine-nvim # Statusline
        tabby-nvim # Tabline
      ];
      views = [
        aerial-nvim # Code outline window
        fidget-nvim # Shows LSP progress in a text box
        trouble-nvim # Sidebar that shows diagnostics and such
        which-key-nvim # Shows keybind groups
      ];
      icons = [
        lspkind-nvim # Add pictograms to built-in lsp
      ];
    };

    # Plugins to lazy load on given languages
    languages = {
      lua = [
        lazydev-nvim # Configure editing nvim configuration files
      ];
      markdown = [
        mkdnflow-nvim # Navigate wiki links
        glow-nvim # Render markdown in nvim terminal
        render-markdown-nvim
      ];
    };
  };

  # shared libraries to be added to LD_LIBRARY_PATH
  # variable available to nvim runtime
  sharedLibraries = with pkgs; {
    tools = {
      utilities = [
        libnotify
      ];
      git = [
        libgit2
      ];
    };
  };

  environmentVariables = {
  };

  extraWrapperArgs = {
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
  };

  # lists of the functions you would have passed to
  # python.withPackages or lua.withPackages
  python3.libraries = {
    system = python-pkgs:
      with python-pkgs; [
        pynvim # Python client for neovim
      ];
    languages = {
      markdown = python-pkgs:
        with python-pkgs; [
          mdformat # Markdown formatter
          pylatexenc # Latex to unicode and back conversion
        ];
      python = python-pkgs:
        with python-pkgs; [
          ruff # Python linter and code formatter
          uv # Package manager for python
        ];
    };
  };

  # Populates $LUA_PATH and $LUA_CPATH
  extraLuaPackages = {
    tools = {
      files = [
        (lua-pkgs:
          with lua-pkgs; [
            magick # Imagemagick lua bindings
            image-nvim # Image library for nvim
          ])
      ];
      snippets = [
        (lua-pkgs:
          with lua-pkgs; [
            jsregexp # JavaScript regex for lua
          ])
      ];
    };
  };

  # Defining language = [ "language" "default"]; in this attrset would
  # cause any import of a subcategory of language to import language.default as well
  extraCats = {
  };
}
