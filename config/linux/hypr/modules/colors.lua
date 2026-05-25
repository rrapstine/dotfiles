--- Colors Configuration ---
-- Uses Catppuccin Mocha theme

local mocha = require("themes.mocha")

local colors = {}

-- Map catppuccin colors to variable names
for key, value in pairs(mocha) do
    colors[key] = value
end

-- Custom color aliases (matching original cachyOS colors where useful)
colors.cachylblue = mocha.blue
colors.cachymblue = mocha.sapphire
colors.cachydblue = mocha.mantle
colors.cachylgreen = mocha.green
colors.cachymgreen = mocha.teal
colors.cachydgreen = mocha.green
colors.cachywhite = mocha.text
colors.cachygrey = mocha.overlay2
colors.cachygray = mocha.overlay1

-- Set global colors for use in other configs
-- These are used by decorations, variables, windowrules, etc.
hl.config({
    general = {
        col = {
            active_border = mocha.mauve,
            inactive_border = "rgba(" .. mocha.rosewater:sub(3) .. "33)",
        }
    },
    decoration = {
        col = {
            active_border = mocha.mauve,
        }
    },
    group = {
        col = {
            border_active = mocha.mauve,
            border_inactive = mocha.mauve,
            border_locked_active = mocha.mauve,
            border_locked_inactive = mocha.rosewater,
        },
        groupbar = {
            text_color = mocha.text,
            col = {
                active = mocha.mauve,
                inactive = mocha.rosewater,
                locked_active = mocha.mauve,
                locked_inactive = mocha.rosewater,
            },
        },
    },
    misc = {
        col = {
            splash = mocha.mauve,
        },
        background_color = mocha.rosewater,
    },
})

-- Also export for direct use in windowrules
return colors