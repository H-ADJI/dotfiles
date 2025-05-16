#!/bin/bash

# Launch applications in the background
alacritty &
brave &
slack &
spotify &

# Wait briefly to ensure the applications have time to start
sleep 1

# Move Alacritty to workspace 1
swaymsg '[app_id="Alacritty"] move to workspace 1'
# swaymsg 'workspace 1'

# Move Brave to workspace 2
swaymsg '[app_id="brave-browser"] move to workspace 2'

# Move Spotify to workspace 2
swaymsg '[class="Spotify"] move to workspace 2'
# swaymsg 'workspace 2'

# Move Slack to workspace 3
swaymsg '[app_id="slack"] move to workspace 3'
# swaymsg 'workspace 3'

exit 0
