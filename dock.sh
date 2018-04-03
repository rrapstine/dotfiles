#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Calendar.app"
dockutil --no-restart --add "/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Calibre.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/Applications/Android Studio.app"
dockutil --no-restart --add "/Applications/Atom.app"
dockutil --no-restart --add "/Applications/GitKraken.app"
dockutil --no-restart --add "/Applications/Postman.app"
dockutil --no-restart --add "/Applications/Sequel Pro.app"
dockutil --no-restart --add "/Applications/Transmit.app"
dockutil --no-restart --add "/Applications/Transmission.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Utilities/Activity Monitor.app"

dockutil --add '~/Documents' --view grid --display folder --sort name
dockutil --add '~/Downloads' --view grid --display folder --sort dateadded
dockutil --add '/Applications' --view grid --display folder --sort name

killall Dock

echo "Success! Dock is set."
