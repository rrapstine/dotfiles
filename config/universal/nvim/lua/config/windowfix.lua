-- [[ Floating Window Background Fix ]]
--  This makes all floating window backgrounds match your editor background,
--  effectively hiding the padding/shadow that NUI creates for rounded borders.
--  This affects notifications, LSP popups, Telescope, and all other floating windows.
--
--  TO DISABLE: Set ENABLED = false below

local M = {}

-- Toggle switch - set to false to disable this entire fix
local ENABLED = true
local last_normal_bg = nil

-- Main function that applies all floating window background fixes
local function fix_float_background()
  if not ENABLED then
    return
  end

  -- Get the current normal background color
  local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
  local normal_bg = normal_hl.bg or "NONE"
  
  -- Skip if background hasn't changed, but still apply to existing windows
  local background_changed = (last_normal_bg ~= normal_bg)
  last_normal_bg = normal_bg
  
  -- Only update highlight groups if background actually changed
  if background_changed then
    -- Force all floating window highlights to use normal background (NvChad approach)
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'FloatTitle', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'FloatFooter', { bg = normal_bg })

    -- Additional highlight groups that might need fixing
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopeTitle', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = normal_bg })

    -- Lazy.nvim specific highlight groups
    vim.api.nvim_set_hl(0, 'LazyNormal', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'LazyBorder', { bg = normal_bg })

    -- Mason specific highlight groups
    vim.api.nvim_set_hl(0, 'MasonNormal', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'MasonBorder', { bg = normal_bg })

    -- Apply the same to notification popups
    vim.api.nvim_set_hl(0, 'NotifyINFOBody', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'NotifyWARNBody', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'NotifyERRORBody', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'NotifyTRACEBody', { bg = normal_bg })

    -- Completion menu (blink.cmp, nvim-cmp)
    vim.api.nvim_set_hl(0, 'Pmenu', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'PmenuSel', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'CmpMenu', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'CmpBorder', { bg = normal_bg })

    -- Dialog/prompt windows (exit dialogs, confirm dialogs)
    vim.api.nvim_set_hl(0, 'Question', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'Confirm', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'MsgArea', { bg = normal_bg })

    -- Additional floating window highlight groups
    vim.api.nvim_set_hl(0, 'WhichKeyFloat', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'DiagnosticFloatingWarn', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { bg = normal_bg })
    vim.api.nvim_set_hl(0, 'DiagnosticFloatingHint', { bg = normal_bg })
  end

  -- Apply winhighlight to all existing floating windows (always run)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_type = vim.fn.win_gettype(win)
    if win_type == 'popup' or win_type == 'float' then
      vim.wo[win].winhighlight = 'Normal:Normal,NormalFloat:Normal,FloatBorder:Normal'
    end
  end
end

function M.setup()
  if not ENABLED then
    return
  end

  -- Apply fix immediately
  fix_float_background()
  
  -- Reapply after colorscheme changes
  vim.api.nvim_create_autocmd('ColorScheme', { 
    callback = function()
      vim.defer_fn(fix_float_background, 50)
    end
  })
  
  -- Apply when specific plugins open their windows
  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'TelescopePrompt', 'lazy', 'mason', 'cmp_menu', 'DressingInput', 'DressingSelect'},
    callback = fix_float_background
  })
  
  -- Also apply to completion menu and dialog windows
  vim.api.nvim_create_autocmd('MenuPopup', {
    callback = fix_float_background
  })
  
  vim.api.nvim_create_autocmd('CmdlineEnter', {
    callback = fix_float_background
  })
  
  -- Aggressive catch-all for any popup creation
  vim.api.nvim_create_autocmd('BufWinEnter', {
    callback = function()
      if vim.fn.win_gettype() == 'popup' or vim.fn.win_gettype() == 'float' then
        vim.defer_fn(fix_float_background, 10)
      end
    end
  })
  
  -- Aggressive catch-all for any popup creation
  vim.api.nvim_create_autocmd('BufWinEnter', {
    callback = function()
      if vim.fn.win_gettype() == 'popup' or vim.fn.win_gettype() == 'float' then
        vim.defer_fn(fix_float_background, 10)
      end
    end
  })
  
  -- Apply to any floating window creation (lightweight)
  vim.api.nvim_create_autocmd('WinNew', {
    callback = function()
      if vim.fn.win_gettype() == 'popup' or vim.fn.win_gettype() == 'float' then
        vim.wo.winhighlight = 'Normal:Normal,NormalFloat:Normal,FloatBorder:Normal'
      end
    end
  })
end

-- Expose toggle function for runtime enable/disable
function M.toggle()
  ENABLED = not ENABLED
  if ENABLED then
    last_normal_bg = nil  -- Reset cache when re-enabling
    fix_float_background()
    vim.notify("Floating window background fix: ENABLED", "info")
  else
    vim.notify("Floating window background fix: DISABLED", "warn")
  end
end

-- Auto-start when file is required
vim.defer_fn(function()
  M.setup()
end, 100)

return M