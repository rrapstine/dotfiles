-- Color definitions
local colors = {
  fill_bg = '#181825',       -- Background fill (matches lualine)
  active_bg = '#1e1e2e',     -- Currently selected/active buffer
  inactive_bg = '#161622',   -- Visible but not active buffers
  modified_fg = '#a6e3a1',   -- Modified file indicator (green)
}

-- Reusable highlight patterns
local fill_style = {
  bg = colors.fill_bg,
  fg = { attribute = 'fg', highlight = 'StatusLine' },
}

local inactive_style = {
  bg = colors.inactive_bg,
  fg = { attribute = 'fg', highlight = 'Normal' },
}

local active_style = {
  bg = colors.active_bg,
  fg = { attribute = 'fg', highlight = 'Normal' },
}

local modified_fill = {
  bg = colors.fill_bg,
  fg = colors.modified_fg,
}

local modified_inactive = {
  bg = colors.inactive_bg,
  fg = colors.modified_fg,
}

local modified_active = {
  bg = colors.active_bg,
  fg = colors.modified_fg,
}

return {
  'akinsho/bufferline.nvim',
  dependencies = { 'catppuccin/nvim', 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      indicator = {
        icon = ' ',
      },
      show_close_icon = false,
      tab_size = 0,
      max_name_length = 25,
      -- offsets = {
      --   {
      --     filetype = 'NvimTree',
      --     text = '  Files',
      --     highlight = 'StatusLine',
      --     text_align = 'left',
      --   },
      {
        filetype = 'neo-tree',
        -- text = function()
        --   return ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        -- end,
        highlight = 'StatusLineComment',
        text_align = 'left',
      },
      -- },
      hover = {
        enabled = true,
        delay = 0,
        reveal = { 'close' },
      },
      separator_style = 'slant',
      modified_icon = '',
      custom_areas = {
        left = function()
          return {
            { text = '    ', fg = '#8fff6d' },
          }
        end,
        right = function()
          return {
            { text = ' ' },
          }
        end,
      },
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match('error') and ' ' or ' '
        return icon .. count
      end,
    },
    highlights = {
      -- Fill and background
      fill = { bg = colors.fill_bg },
      background = { bg = colors.fill_bg },
      
      -- Buffer states
      buffer_visible = inactive_style,
      buffer_selected = vim.tbl_extend('force', active_style, { bold = true, italic = true }),
      
      -- Close buttons
      close_button = fill_style,
      close_button_visible = inactive_style,
      close_button_selected = active_style,
      
      -- Modified indicators
      modified = modified_fill,
      modified_visible = modified_inactive,
      modified_selected = modified_active,
      
      -- Diagnostics
      diagnostic = fill_style,
      diagnostic_visible = inactive_style,
      hint = fill_style,
      hint_visible = inactive_style,
      info = fill_style,
      info_visible = inactive_style,
      warning = fill_style,
      warning_visible = inactive_style,
      error = fill_style,
      error_visible = inactive_style,
      hint_diagnostic = fill_style,
      hint_diagnostic_visible = inactive_style,
      info_diagnostic = fill_style,
      info_diagnostic_visible = inactive_style,
      warning_diagnostic = fill_style,
      warning_diagnostic_visible = inactive_style,
      error_diagnostic = fill_style,
      error_diagnostic_visible = inactive_style,
      
      -- Duplicates
      duplicate = fill_style,
      duplicate_visible = inactive_style,
      
      -- Separators
      separator = { fg = colors.fill_bg, bg = colors.fill_bg },
      separator_selected = { fg = colors.fill_bg, bg = colors.active_bg },
      separator_visible = { fg = colors.fill_bg, bg = colors.inactive_bg },
      
      -- Misc
      trunc_marker = { bg = colors.fill_bg },

      -- Tabs
      tab = fill_style,
      tab_separator = { fg = colors.fill_bg, bg = colors.fill_bg },
      tab_separator_selected = { fg = colors.fill_bg },
      tab_close = { bg = colors.fill_bg },
    },
  },
}
