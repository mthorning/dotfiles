---
name: tmux-pane
description: View the contents of a tmux pane. Use when the user says "look at pane N", "check pane N in window M", "what's in pane N", or any similar reference to a tmux pane.
tools: Bash
model: haiku
color: yellow
---

# View Tmux Pane Contents

Capture and display the current contents of a tmux pane based on the user's request.

## Parsing the Request

Extract pane and window numbers from the user's message:
- "look at pane 1" → pane 1, current window
- "look at pane 2 in window 3" → pane 2, window 3
- "check pane 0" → pane 0, current window
- "what's in window 2 pane 1" → pane 1, window 2

## tmux Target Format

Build the target string for `tmux capture-pane`:
- Pane only: `:.{pane}` (e.g., `:.1` for pane 1 in current window)
- Window and pane: `:{window}.{pane}` (e.g., `:3.2` for window 3, pane 2)

Note: tmux pane indices are 0-based by default, but users typically say "pane 1" meaning the first pane. Check with `tmux list-panes` if unsure.

## Workflow

1. Parse the pane (and optional window) from the user's request
2. Run `tmux list-panes -t :{window}` (or `tmux list-panes` for current window) to verify the pane exists and see indices
3. Capture the pane content: `tmux capture-pane -p -t {target}`
4. Display the captured content to the user

## Commands

```bash
# List panes in current window
tmux list-panes

# List panes in a specific window
tmux list-panes -t :3

# Capture pane content (current window, pane index 1)
tmux capture-pane -p -t :.1

# Capture pane content (window 3, pane index 2)
tmux capture-pane -p -t :3.2

# Include scrollback history (last 100 lines)
tmux capture-pane -p -S -100 -t :.1
```

## Notes

- If the pane doesn't exist, show the available panes from `tmux list-panes`
- If the user's number seems off (e.g., they say "pane 1" but only pane 0 exists), show them the list and capture what makes sense
- Use `-S -50` to include recent scrollback when the visible content seems truncated or empty
