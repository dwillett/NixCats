-- <nixCats>/lua/pluginConf/paq.lua
-- Configuring nvim to run without nixCats

-- Include the required plugin list for paq-nvim to download
require("nixCatsUtils.catPaq").setup({
  --[[ ------------------------------------------ ]]
  --[[ The way to think of this is, its very      ]]
  --[[ similar to the main nix file for nixCats   ]]
  --[[                                            ]]
  --[[ It can be used to download your plugins,   ]]
  --[[ and it has an opt for optional plugins.    ]]
  --[[                                            ]]
  --[[ We dont want to handle anything about      ]]
  --[[ loading those plugins here, so that we can ]]
  --[[ use the same loading code that we use for  ]]
  --[[ our normal nix-loaded config.              ]]
  --[[ we will do all our loading and configuring ]]
  --[[ elsewhere in our configuration, so that    ]]
  --[[ we dont have to write it twice.            ]]
  --[[ ------------------------------------------ ]]

  -- Non-nix plugins
  { "williamboman/mason.nvim", opt = true },
  { "williamboman/mason-lspconfig.nvim", opt = true },
  { "jay-babu/mason-nvim-dap.nvim", opt = true },

  -- Startup plugins
  -- Util
  { "BirdeeHub/lze" },
  { "BirdeeHub/lzextras" },
  { "stevearc/oil.nvim" },
  { "folke/snacks.nvim" },
  -- UI
  { "MunifTanjim/nui.nvim", opt = true },
  { "nvim-tree/nvim-web-devicons" },

  -- Lazy loaded plugins
  -- Coding
  { "saghen/blink.cmp", opt = true },
  { "saghen/blink.compat", opt = true },
  { "moyiz/blink-emoji.nvim", opt = true },
  { "mikavilpas/blink-ripgrep.nvim", opt = true },
  { "L3MON4D3/LuaSnip", opt = true },
  { "rafamadriz/friendly-snippets", opt = true },
  -- Debug
  { "nvim-neotest/nvim-nio", opt = true },
  { "mfussenegger/nvim-dap", opt = true },
  { "rcarriga/nvim-dap-ui", opt = true },
  { "theHamsta/nvim-dap-virtual-text", opt = true },
  -- Editor
  { "echasnovski/mini.nvim", opt = true },
  { "folke/flash.nvim", opt = true },
  { "MagicDuck/grug-far.nvim", opt = true },
  { "folke/which-key.nvim", opt = true },
  { "lewis6991/gitsigns.nvim", opt = true },
  { "folke/trouble.nvim", opt = true },
  -- Formatting
  { "stevearc/conform.nvim", opt = true },
  { "mfussenegger/nvim-lint", opt = true },
  -- LSP
  { "neovim/nvim-lspconfig", opt = true },
  { "folke/lazydev.nvim", opt = true },
  -- Markdown
  { "jakewvincent/mkdnflow.nvim", opt = true },
  { "ellisonleao/glow.nvim", opt = true },
  { "MeanderingProgrammer/render-markdown.nvim", opt = true },
  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", opt = true, build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context", opt = true },
  { "nvim-treesitter/nvim-treesitter-refactor", opt = true },
  { "nvim-treesitter/nvim-treesitter-textobjects", opt = true },
  -- Ui
  { "catppuccin/nvim", opt = true },
  { "scottmckendry/cyberdream.nvim", opt = true },
  { "ellisonleao/gruvbox.nvim", opt = true },
  { "f4z3r/gruvbox-material.nvim", opt = true },
  { "rebelot/kanagawa.nvim", opt = true },
  { "savq/melange-nvim", opt = true },
  { "EdenEast/nightfox.nvim", opt = true },
  { "joshdick/onedark.vim", opt = true },
  { "nvim-lualine/lualine.nvim", opt = true },
  { "nanozuki/tabby.nvim", opt = true },
  { "stevearc/aerial.nvim", opt = true },
  { "onsails/lspkind.nvim", opt = true },
  -- Util
  { "nvim-lua/plenary.nvim", opt = true },
  { "epwalsh/pomo.nvim", opt = true },
  { "axieax/urlview.nvim", opt = true },
})
