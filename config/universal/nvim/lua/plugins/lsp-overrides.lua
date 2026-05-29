return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      emmet_ls = {
        filetypes = {
          "css",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "svelte",
          "pug",
          "typescriptreact",
          "typescript.tsx",
          "vue",
        },
        init_options = {
          showExpandedAbbreviation = "always",
          showAbbreviationSuggestions = true,
          showSuggestionsAsSnippets = false,
          syntaxProfiles = {},
          variables = {},
          excludeLanguages = {},
        },
      },
    },
  },
}