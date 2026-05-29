return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      stylua = {
        inherit = true,
        prepend_args = {
          "--config-path",
          vim.fn.stdpath("config") .. "/lua/config/formatters/stylua.toml",
        },
      },
    },
  },
}