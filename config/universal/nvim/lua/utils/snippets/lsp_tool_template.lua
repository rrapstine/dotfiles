--[[
LSP TOOL TEMPLATE
=================

This template helps you create new LSP tool configurations following the
principle of "only specify what needs to change from nvim-lspconfig defaults".

MERGING BEHAVIOR:
================
vim.lsp.config() has specific merging behavior:

FIELDS THAT REPLACE (completely override defaults):
  - filetypes: Array of filetypes this LSP handles
  - root_dir: Function for detecting project root
  - cmd: Command to start the LSP server
  - init_options: Initial options passed to server
  - handlers: Custom LSP request/response handlers
  - capabilities: Modify server capabilities
  - single_file_support: Boolean for single-file mode

FIELDS THAT MERGE (deep-merged with defaults):
  - settings: Server-specific configuration (most common customizations)

USAGE:
=====
1. Copy this template to lua/config/lsp/tools/your_tool_name.lua
2. Uncomment and modify only the fields you need to change
3. Leave everything else commented to use nvim-lspconfig defaults

EXAMPLE:
-------
For most LSPs, you'll only need to modify the settings field:

return {
  roles = { 'lsp' },
  lsp = {
    -- filetypes = { 'your', 'filetypes' },  -- Uncomment ONLY if adding/removing support
    -- root_dir = function(bufnr) ... end,  -- Uncomment ONLY if custom root detection needed
    
    settings = {
      your_lsp_name = {
        -- Your custom settings here
        someSetting = true,
        anotherSetting = 'value',
      },
    },
  },
}
--]]

return {
  roles = { 'lsp' }, -- Add 'formatter' or 'linter' if this tool serves multiple roles
  
  lsp = {
    -- === REPLACEMENT FIELDS (uncomment ONLY if you need different behavior) ===
    
    -- filetypes = { 'default', 'filetypes' }, -- Removes all default filetypes and uses these ONLY
                                          -- Use only to add NEW filetypes or remove support
                                          
    -- root_dir = function(bufnr) -- Custom root detection logic
    --   return vim.fs.root(bufnr, { 'package.json', '.git' }) -- Example
    -- end,
    
    -- cmd = { 'custom-command', '--stdio' }, -- Custom server command
    -- init_options = { customOption = true }, -- Custom init options
    -- single_file_support = false, -- Disable single-file mode
    
    -- === MERGING FIELDS (safe to modify - these merge with defaults) ===
    
    settings = {
      -- Replace 'your_lsp_name' with the actual LSP name
      -- This gets deep-merged with nvim-lspconfig defaults
      your_lsp_name = {
        -- Most customizations go here
        -- exampleSetting = true,
        -- anotherSetting = 'value',
      },
    },
    
    -- === ADVANCED FIELDS (rarely needed, replace defaults) ===
    
    -- handlers = {
    --   -- Custom LSP request/response handlers
    --   ['textDocument/publishDiagnostics'] = function() end,
    -- },
    
    -- capabilities = {
    --   -- Modify server capabilities (advanced use cases)
    --   textDocument = {
    --     -- Example: Disable specific capabilities
    --     completion = nil,
    --   },
    -- },
  },
}