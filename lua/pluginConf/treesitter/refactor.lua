-- <nixCats>/lua/pluginConf/treesitter/refactor.lua
-- Treesitter config for refactor settings

return {
  -- Highlight definition and usage for the current symbol
  highlight_definitions = {
    enable = false,
    clear_on_cursor_move = true,
  },
  -- Highlight the block from the current scope
  highlight_current_scope = { enable = false },
  -- Renames the symbol under the cursor in this file
  smart_rename = {
    enable = true,
    keymaps = {
      smart_rename = "<leader>cR",
    },
  },
  -- Go to definition for the symbol under cursor
  navigation = {
    enable = true,
    keymaps = {
      goto_definition = "gnd",
      list_definitions = "gnD",
      list_definitions_toc = "g0",
      goto_next_usage = "<a-*>",
      goto_previous_usage = "<a-#>",
    },
  },
}
