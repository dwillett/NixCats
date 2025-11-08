-- General keymaps following LazyVim conventions
-- https://www.lazyvim.org/keymaps

local map = vim.keymap.set

-- Better up/down (deal with word wrap)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-Left>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-Down>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-Up>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-j>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-k>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
map("n", "<C-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
  if require("nixCatsUtils").enableForCategory("util") then
    require("snacks").bufdelete()
  else
    vim.cmd("bdelete")
  end
end, { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- location and quickfix lists
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- formatting (using conform.nvim when available)
map({ "n", "v" }, "<leader>cf", function()
  if require("nixCatsUtils").enableForCategory("formatting") then
    require("conform").format()
  else
    vim.lsp.buf.format()
  end
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- toggle options
local snacks = require("nixCatsUtils").enableForCategory("util") and require("snacks") or nil

if snacks then
  -- Using snacks for toggles
  map("n", "<leader>us", function()
    snacks.toggle.option("spell"):toggle()
  end, { desc = "Toggle Spelling" })
  map("n", "<leader>uw", function()
    snacks.toggle.option("wrap"):toggle()
  end, { desc = "Toggle Word Wrap" })
  map("n", "<leader>uL", function()
    snacks.toggle.option("relativenumber"):toggle()
  end, { desc = "Toggle Relative Line Numbers" })
  map("n", "<leader>ud", function()
    snacks.toggle.diagnostics():toggle()
  end, { desc = "Toggle Diagnostics" })
  map("n", "<leader>ul", function()
    snacks.toggle.line_number():toggle()
  end, { desc = "Toggle Line Numbers" })
  map("n", "<leader>uc", function()
    snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):toggle()
  end, { desc = "Toggle Conceal" })
  map("n", "<leader>uT", function()
    if vim.b.ts_highlight then
      vim.treesitter.stop()
    else
      vim.treesitter.start()
    end
  end, { desc = "Toggle Treesitter Highlight" })
  map("n", "<leader>ub", function()
    snacks.toggle.option("background", { off = "light", on = "dark" }):toggle()
  end, { desc = "Toggle Background" })
  if vim.lsp.inlay_hint then
    map("n", "<leader>uh", function()
      snacks.toggle.inlay_hints():toggle()
    end, { desc = "Toggle Inlay Hints" })
  end
else
  -- Manual toggles without snacks
  map("n", "<leader>us", "<cmd>setlocal spell!<cr>", { desc = "Toggle Spelling" })
  map("n", "<leader>uw", "<cmd>setlocal wrap!<cr>", { desc = "Toggle Word Wrap" })
  map("n", "<leader>ul", "<cmd>setlocal number!<cr>", { desc = "Toggle Line Numbers" })
  map("n", "<leader>uL", "<cmd>setlocal relativenumber!<cr>", { desc = "Toggle Relative Line Numbers" })
  map("n", "<leader>ud", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = "Toggle Diagnostics" })
  map("n", "<leader>uc", function()
    local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
    vim.opt_local.conceallevel = vim.o.conceallevel == 0 and conceallevel or 0
  end, { desc = "Toggle Conceal" })
  map("n", "<leader>uT", function()
    if vim.b.ts_highlight then
      vim.treesitter.stop()
    else
      vim.treesitter.start()
    end
  end, { desc = "Toggle Treesitter Highlight" })
  map("n", "<leader>ub", function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
  end, { desc = "Toggle Background" })
  if vim.lsp.inlay_hint then
    map("n", "<leader>uh", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { desc = "Toggle Inlay Hints" })
  end
end

-- LazyVim terminal mappings (if using snacks)
if snacks then
  map("n", "<leader>ft", function()
    snacks.terminal()
  end, { desc = "Terminal (Root Dir)" })
  map("n", "<leader>fT", function()
    snacks.terminal(nil, { cwd = vim.fn.expand("%:p:h") })
  end, { desc = "Terminal (cwd)" })
  map("n", "<c-/>", function()
    snacks.terminal()
  end, { desc = "Terminal (Root Dir)" })
  map("n", "<c-_>", function()
    snacks.terminal()
  end, { desc = "which_key_ignore" })

  -- Terminal mappings
  map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
  map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
  map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
  map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
end

-- windows
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
