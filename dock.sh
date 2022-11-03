#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Mail.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Firefox Developer Edition.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/System/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Discord.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/Applications/Wrike for Mac.app"
dockutil --no-restart --add "/Applications/Eagle.app"
dockutil --no-restart --add "/Applications/Figma.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/GitKraken.app"
dockutil --no-restart --add "/Applications/Insomnia.app"
dockutil --no-restart --add "/Applications/Warp.app"
dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"

dockutil --add '~/Documents' --view grid --display folder --sort name
dockutil --add '~/Downloads' --view grid --display folder --sort dateadded
dockutil --add '/Applications' --view grid --display folder --sort name

killall Dock

echo "Success! Dock is set."