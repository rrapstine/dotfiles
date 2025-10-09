return {
  roles = { 'lsp' },
  lsp = {
    filetypes = { 
      'css', 
      'html', 
      'javascript', 
      'javascriptreact', 
      'less', 
      'sass', 
      'scss', 
      'svelte', 
      'pug', 
      'typescriptreact', 
      'typescript.tsx',
      'vue' 
    },
    init_options = {
      --- @type table<string, any> https://docs.emmet.io/customization/preferences/
      preferences = {},
      --- @type "always" | "never" defaults to "always"
      showExpandedAbbreviation = "always",
      --- @type boolean defaults to true
      showAbbreviationSuggestions = true,
      --- @type boolean defaults to false
      showSuggestionsAsSnippets = false,
      --- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
      syntaxProfiles = {},
      --- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
      variables = {},
      --- @type string[]
      excludeLanguages = {},
    },
  },
}
