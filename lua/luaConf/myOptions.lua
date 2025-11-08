-- <nixCats>/lua/luaConf/myOptions.lua

-- Needs to be setup before everything, leader key
vim.api.nvim_set_keymap("", " ", "", { noremap = true })
vim.api.nvim_set_keymap("", "\\", "", { noremap = true })
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Copy pasting in wayland
if os.getenv("WAYLAND_DISPLAY") and vim.fn.exepath("wl-copy") ~= "" then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
    cache_enabled = 1,
  }
end

local opt = vim.opt

opt.autowrite = true
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.colorcolumn = "120" -- Set demarkation at 80 lines
opt.completeopt = { "menu", "preview", "noselect" }
opt.conceallevel = 2 -- Plugins need this
opt.confirm = true
opt.cpoptions:append("I") -- Don't delete new indent if cursor is moved
opt.cursorcolumn = false -- Disable column highlight
opt.cursorline = true -- Disable line highlight
opt.expandtab = true -- whether to turn tabs into spaces or not
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit" -- preview incremental substitute
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}
opt.mouse = "a"
opt.number = true -- Line numbers
opt.numberwidth = 4 -- Number column width
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Max number of entries in a popup
opt.relativenumber = true -- Show relative numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftwidth = 2 -- default # of spaces for auto-indent step
opt.showmode = false -- Don't show mode
opt.showtabline = 2 -- Show the top tabline even with a single tab
opt.sidescrolloff = 8 -- If no wrap, keep this many lines off cursor
opt.signcolumn = "yes" -- Always show sign column
opt.smartcase = true
opt.smartindent = true
opt.smoothscroll = true
opt.softtabstop = 4 -- # of spaces to enter instead of tab in edit
opt.spell = false -- Turn off spellchecking
opt.spelllang = { "en" }
opt.splitbelow = true -- Force split direction
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2 -- # of spaces to render for actual tabs
opt.termguicolors = true -- set term gui colors
opt.timeoutlen = 2000 -- Need the timeout
opt.title = false -- Don't show title
opt.undofile = true -- Keep undo history
opt.undolevels = 10000
opt.updatetime = 200
opt.wrap = false -- Don't wrap long lines
