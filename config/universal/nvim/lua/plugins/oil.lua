return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    default_file_explorer = true,
    columns = {},
    keymaps = {
      ["<C-h>"] = false,
      ["<C-c>"] = false,
      ["q"] = "actions.close",
    },
    delete_to_trash = true,
    view_options = { show_hidden = true },
    skip_confirm_for_simple_edits = true,
  },
}