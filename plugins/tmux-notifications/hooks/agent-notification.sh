#!/bin/bash
# Tmux Status Line Notifications Hook
# Shows indicator in tmux status line when agents complete

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Quick exit if not in tmux
if [ -z "${TMUX:-}" ]; then
  exit 0
fi

# Extract hook event details
HOOK_EVENT=$(echo "$HOOK_INPUT" | jq -r '.hook_event_name // "unknown"')

# Get current tmux session and window
TMUX_SESSION=$(tmux display-message -p '#{session_name}')
TMUX_WINDOW=$(tmux display-message -p '#{window_index}')

# Duration in seconds
DURATION=5

# Icon to display
ICON="◉"

# Write indicator file for tmux status bar to display the icon
INDICATOR_FILE="/tmp/tmux-claude-${TMUX_SESSION}-${TMUX_WINDOW}"
echo "$ICON" > "$INDICATOR_FILE"

# Clear indicator after duration to avoid clutter
(sleep "$DURATION" && rm -f "$INDICATOR_FILE") &

exit 0
