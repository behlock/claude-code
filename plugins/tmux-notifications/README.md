# Tmux Notifications Plugin

Get instant tmux status line notifications when Claude Code agents complete their work.

## Overview

This plugin integrates Claude Code with tmux's status line, showing a simple indicator (`◉`) next to your window when agents complete or events fire.

## Installation

1. Install the plugin:
   ```bash
   # In Claude Code:
   /plugin install ./plugins/tmux-notifications
   ```

2. Add to your tmux config:
   ```bash
   # Show Claude notification indicator next to window names
   set -g window-status-format "#I:#W#(cat /tmp/tmux-claude-#{session_name}-#{window_index} 2>/dev/null)"
   set -g window-status-current-format "#I:#W#(cat /tmp/tmux-claude-#{session_name}-#{window_index} 2>/dev/null)"
   ```

3. Reload tmux config:
   ```bash
   tmux source-file <tmux_config>
   ```

## How It Works

When Claude Code fires an event (agent completion, stop, or notification), the hook:
1. Writes `◉` to `/tmp/tmux-claude-{session}-{window}`
2. Indicator appears next to the window name in your status line
3. Auto-clears after 5 seconds

Example: `0:vim◉  1:bash  2:logs`

## Customization

### Change Duration

Edit `/plugins/tmux-notifications/hooks/agent-notification.sh`:

```bash
# Duration in seconds
DURATION=5  # Change to 3, 10, etc.
```

### Change Icon

```bash
ICON="◉"  # Change to ✓, ⚡, etc.
```

### Filter Events

Edit `hooks/hooks.json`, remove `Stop` and `Notification` blocks if needed.


## Troubleshooting

### Indicator Not Showing

1. Check you're in tmux:
   ```bash
   echo $TMUX  # Should output: /tmp/tmux-XXX/...
   ```

2. Verify tmux config was loaded:
   ```bash
   tmux show-options -g window-status-format
   # Should include: /tmp/tmux-claude-
   ```

3. Test manually:
   ```bash
   echo '{"hook_event_name":"SubagentStop"}' | bash plugins/tmux-notifications/hooks/agent-notification.sh
   # Indicator should appear for 5 seconds
   ```

4. Check indicator file:
   ```bash
   cat /tmp/tmux-claude-$(tmux display-message -p '#{session_name}-#{window_index}')
   # Should show: ◉
   ```
