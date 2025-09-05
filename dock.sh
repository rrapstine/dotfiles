#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Calendar.app"
dockutil --no-restart --add "/Applications/Canary Mail.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Firefox Developer Edition.app"
dockutil --no-restart --add "/System/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Discord.app"
dockutil --no-restart --add "/Applications/Anytype.app"
dockutil --no-restart --add "/Applications/Obsidian.app"
dockutil --no-restart --add "/Applications/Figma.app"
dockutil --no-restart --add "/Applications/Penpot.app"
dockutil --no-restart --add "/Applications/Bruno.app"
dockutil --no-restart --add "/Applications/WezTerm.app"
dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"

dockutil --add '~/Documents' --view grid --display folder --sort name
dockutil --add '~/Downloads' --view grid --display folder --sort dateadded
dockutil --add '/Applications' --view grid --display folder --sort name

killall Dock

echo "Success! Dock is set."
