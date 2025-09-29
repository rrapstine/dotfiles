-- lua/config/lsp/tools.lua
-- One file to manage ALL tools (LSP servers, formatters, linters) for Mason, LSPconfig, Conform, etc.

local M = {}

----------------------------------------------------------------------------
-- 1) Define your tools here.
--
-- Each key must exactly match the Mason registry name for that tool (e.g. "pyright", "lua_ls", "prettier", "black", "biome", etc.).
--
-- Every entry is a table with at least:
--    type = { "lsp" / "formatter" / "linter", … }
--
-- You MAY omit the "lsp" subtable if you just want the default LSP config (i.e. {})
-- You MAY omit the "formatter" subtable if you just want Conform to invoke the binary with no extra args,
--   but in that case you MUST specify a top-level "filetypes" list so we know which filetypes to hook.
-- You MAY omit the "linter" subtable if you aren’t using nvim-lint.
--
-- If you declare type = { "formatter" } but forget "filetypes", you’ll get an error at startup.
----------------------------------------------------------------------------

M.tools = {
  --------------------------------------------------------------------------
  -- LSPs
  --------------------------------------------------------------------------
  lua_ls = {
    type = { 'lsp' },
  },

  bashls = {
    type = { 'lsp' },
  },

  vtsls = {
    type = { 'lsp' },
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'jsonc' },
    root_dir = { 'package.json', '.git' },
  },

  gopls = {
    type = { 'lsp' },
    filetypes = { 'go' },
  },

  intelephense = {
    type = { 'lsp' },
    filetypes = { 'php' },
  },

  dockerls = {
    type = { 'lsp' },
  },

  terraformls = {
    type = { 'lsp' },
    lsp = {
      document_highlight = {
        enabled = false,
      },
    },
  },

  --------------------------------------------------------------------------
  -- Formatters
  --------------------------------------------------------------------------
  stylua = {
    type = { 'formatter' },
    filetypes = { 'lua' },
    formatter = {
      args = { '--config-path', vim.fn.stdpath('config') .. '/lua/config/formatting/stylua.toml', '-' },
    },
  },

  beautysh = {
    type = { 'formatter' },
    filetypes = { 'bash' },
  },

  --------------------------------------------------------------------------
  -- Hybrids
  --------------------------------------------------------------------------
  fish_lsp = {
    type = { 'lsp', 'formatter' },
    filetypes = { 'fish' },
  },

  superhtml = {
    type = { 'lsp', 'formatter' },
    filetypes = { 'html' },
  },

  biome = {
    type = { 'formatter', 'linter' },

    formatter = {
      args = {
        'format',
        '--config-path',
        vim.fn.stdpath('config') .. '/lua/config/formatters/biome.jsonc',
        '$FILENAME',
      },
      filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
    },

    linter = {
      command = 'biome',
      args = {
        'lint',
        '--config-path',
        vim.fn.stdpath('config') .. '/lua/config/formatters/biome.jsonc',
        '$FILENAME',
      },
      filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
    },
  },

  --------------------------------------------------------------------------
  -- Example: a hybrid tool (LSP + formatter + linter) like Biome.
  -- Here we do show all the subtables, but if any are missing you'd get defaults or an error.
  --------------------------------------------------------------------------
  -- biome = {
  --   type = { 'lsp', 'formatter', 'linter' },
  --
  --   -- Because we gave a real "lsp" table, this will be passed verbatim to `lspconfig.biome.setup(...)`.
  --   lsp = {
  --     filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
  --     settings = {},
  --     root_dir = { 'biome.json', 'package.json', '.git' },
  --   },
  --
  --   -- We want Conform to run:
  --   --    biome format --stdin-file-path "$FILENAME" --config-path ~/.config/nvim/formatters/biome.json -
  --   formatter = {
  --     args = {
  --       'format',
  --       '--stdin-file-path',
  --       '$FILENAME',
  --       '--config-path',
  --       vim.fn.stdpath('config') .. '/lua/config/formatters/biome.json',
  --       '-',
  --     },
  --     filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
  --   },
  --
  --   -- We want nvim-lint to run:
  --   --    biome lint --stdin-file-path "$FILENAME" --config-path ~/.config/nvim/linters/biome.json -
  --   linter = {
  --     command = 'biome',
  --     args = {
  --       'lint',
  --       '--stdin-file-path',
  --       '$FILENAME',
  --       '--config-path',
  --       vim.fn.stdpath('config') .. '/lua/config/linters/biome.json',
  --       '-',
  --     },
  --     filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
  --   },
  -- },

  --------------------------------------------------------------------------
  --[[
  -- If you wanted to add Prettier purely as a formatter with no custom args,
  -- just do this (no "formatter" subtable needed because Conform will use the
  -- binary name directly):
  prettier = {
    type      = { "formatter" },
    filetypes = { "javascript", "typescript", "css", "html", "json" },
  },
  ]]
  --------------------------------------------------------------------------
}

----------------------------------------------------------------------------
-- 2) Validation / Normalization
--    As soon as this module is required, we’ll:
--     • Check that every “formatter” entry has a non-empty filetypes list.
--     • Check that every “linter” entry has a non-empty filetypes list.
--     • For any tool with type = { "lsp" } but no cfg.lsp, we auto-assign cfg.lsp = {}.
--    This gives you good error messages if you forget something, yet lets you
--    omit empty subtables when you don’t need them.
----------------------------------------------------------------------------

for tool_name, cfg in pairs(M.tools) do
  -- Must have a "type" field that is a table of strings
  if type(cfg.type) ~= 'table' then
    error(('[mason_tools] %q: `type` must be a table, e.g. { \'lsp\' }, { \'formatter\' }, or { \'lsp\', \'formatter\' }'):format(tool_name))
  end

  -- If this tool is declared as "lsp" but no cfg.lsp → give it the empty table
  if vim.tbl_contains(cfg.type, 'lsp') then
    if cfg.lsp == nil then
      cfg.lsp = {} -- auto-create default LSP settings
    end
    if type(cfg.lsp) ~= 'table' then
      error(('[mason_tools] %q: if type contains \'lsp\', then `lsp` must be a table'):format(tool_name))
    end
  end

  -- If this tool is declared as "formatter", ensure we have either a `formatter` subtable OR a top-level `filetypes`
  if vim.tbl_contains(cfg.type, 'formatter') then
    local has_fmt_sub = type(cfg.formatter) == 'table'
    local has_ft = type(cfg.filetypes) == 'table'
    if not has_fmt_sub and not has_ft then
      error(('[mason_tools] %q: declared as formatter but missing both a `formatter` subtable and a top-level `filetypes`.'):format(tool_name))
    end
    -- If you did supply a `formatter` subtable, it must be a table
    if has_fmt_sub and type(cfg.formatter) ~= 'table' then
      error(('[mason_tools] %q: `formatter` must be a table'):format(tool_name))
    end
    -- If you did supply filetypes at top level, they must be a table of strings
    if has_ft then
      for _, ft in ipairs(cfg.filetypes) do
        if type(ft) ~= 'string' then
          error(('[mason_tools] %q: all entries in `filetypes` must be strings (got %s)'):format(tool_name, type(ft)))
        end
      end
    end
  end

  -- If this tool is declared as "linter", require a `linter` subtable with `args` and `filetypes`
  if vim.tbl_contains(cfg.type, 'linter') then
    if type(cfg.linter) ~= 'table' then
      error(('[mason_tools] %q: declared as \'linter\' but missing a `linter` subtable.'):format(tool_name))
    end
    if type(cfg.linter.filetypes) ~= 'table' then
      error(('[mason_tools] %q: `linter.filetypes` must be a list of strings.'):format(tool_name))
    end
    if type(cfg.linter.args) ~= 'table' then
      error(('[mason_tools] %q: `linter.args` must be a list of strings.'):format(tool_name))
    end
  end
end

----------------------------------------------------------------------------
-- 3) Exported helper: get_mason_config()
--    Returns a flat list of names for `mason-tool-installer` → ensure_installed.
----------------------------------------------------------------------------

function M.get_mason_config()
  local names = {}
  for tool_name, _ in pairs(M.tools) do
    table.insert(names, tool_name)
  end
  return names
end

----------------------------------------------------------------------------
-- 4) Exported helper: get_lspconfig_servers()
--    Builds { server_name = config_table } for any tool where type contains "lsp".
--    If you omitted a custom `lsp` subtable, we already auto-filled it with {} above.
----------------------------------------------------------------------------

function M.get_lspconfig_servers()
  local servers = {}
  for tool_name, cfg in pairs(M.tools) do
    if vim.tbl_contains(cfg.type or {}, 'lsp') then
      -- cfg.lsp must exist (possibly {}), per our validation step
      servers[tool_name] = cfg.lsp
    end
  end
  return servers
end

----------------------------------------------------------------------------
-- 5) Exported helper: get_conform_config()
--    Builds Conform’s `formatters_by_ft = { ft = { <tool1>, <tool2>, … } }`.
--
--    • If you specified a `formatter` subtable, we use its `filetypes`.
--    • Otherwise, we use your top-level `filetypes` for that tool.
--    • We do NOT require any extra “args” if you didn’t give them;
--      Conform will just invoke the binary name by default.
----------------------------------------------------------------------------

function M.get_conform_config()
  local ft_map = {}
  local formatter_defs = {}

  for tool_name, cfg in pairs(M.tools) do
    if vim.tbl_contains(cfg.type or {}, 'formatter') then
      -- Decide which filetypes to use:
      local fts = {}
      if type(cfg.formatter) == 'table' and type(cfg.formatter.filetypes) == 'table' then
        fts = cfg.formatter.filetypes
      elseif type(cfg.filetypes) == 'table' then
        fts = cfg.filetypes
      else
        -- Should never happen, because we validated above
        error(('[mason_tools] %q: unable to determine filetypes for formatter'):format(tool_name))
      end

      -- Register <tool_name> under each filetype:
      for _, ft in ipairs(fts) do
        ft_map[ft] = ft_map[ft] or {}
        table.insert(ft_map[ft], tool_name)
      end

      -- Generate custom formatter_defs, if "args" is declared
      if cfg.formatter and cfg.formatter.args then
        formatter_defs[tool_name] = {
          inherit = true,
          prepend_args = cfg.formatter.args,
        }
      end
    end
  end

  return ft_map, formatter_defs
end

----------------------------------------------------------------------------
-- 6) (Optional) Exported helper: get_nvim_lint_config()
--    Builds { ft = { { cmd = {...}, args = {...} }, … } } for any tool with type = "linter".
----------------------------------------------------------------------------

function M.get_nvim_lint_config()
  local lint_map = {}

  for tool_name, cfg in pairs(M.tools) do
    if vim.tbl_contains(cfg.type or {}, 'linter') then
      -- We validated above that cfg.linter.cmd/args/filetypes are all tables/strings
      local def = {
        cmd = { cfg.linter.command or tool_name },
        args = cfg.linter.args,
      }
      for _, ft in ipairs(cfg.linter.filetypes) do
        lint_map[ft] = lint_map[ft] or {}
        table.insert(lint_map[ft], def)
      end
    end
  end

  return lint_map
end

return M
