## Modifier Hierarchy

1. **Ctrl**: Core navigation (pane focus movement)
2. **Super (Cmd)**: Tab-level operations
3. **Super + Ctrl**: Pane resizing
4. **Super + Shift**: Destructive operations (close, split down)

## Ghostty Configuration

Ghostty is configured to handle its own tab management while passing through pane/session management to Zellij:

```
# Ghostty tab management
keybind = cmd+shift+t=new_tab
# Tab reordering
keybind = cmd+ctrl+shift+left=move_tab:-1
keybind = cmd+ctrl+shift+right=move_tab:1

# Pass through to Zellij for pane navigation
keybind = ctrl+h=unbind
keybind = ctrl+j=unbind
keybind = ctrl+k=unbind  
keybind = ctrl+l=unbind

# Pass through to Zellij for tab navigation
keybind = cmd+h=unbind
keybind = cmd+l=unbind
keybind = cmd+t=unbind
keybind = cmd+w=unbind

# Pass through to Zellij for pane splitting
keybind = cmd+d=unbind
keybind = cmd+shift+d=unbind
keybind = cmd+shift+w=unbind

# Pass through to Zellij for pane resizing
keybind = cmd+ctrl+h=unbind
keybind = cmd+ctrl+j=unbind
keybind = cmd+ctrl+k=unbind
keybind = cmd+ctrl+l=unbind

# Pass through to Zellij for tab reordering
keybind = cmd+ctrl+shift+h=unbind
keybind = cmd+ctrl+shift+l=unbind
```

## Zellij Configuration

### Normal Mode Keybinds

#### Tab Navigation (Zellij Sessions)
- `Cmd + h`: Previous tab
- `Cmd + l`: Next tab  
- `Cmd + t`: New tab
- `Cmd + w`: Close tab
- `Cmd + Ctrl + Shift + h`: Move tab left
- `Cmd + Ctrl + Shift + l`: Move tab right

#### Pane Navigation
- `Ctrl + h`: Move focus left
- `Ctrl + j`: Move focus down
- `Ctrl + k`: Move focus up
- `Ctrl + l`: Move focus right

#### Pane Resizing
- `Cmd + Ctrl + h`: Resize increase left
- `Cmd + Ctrl + j`: Resize increase down
- `Cmd + Ctrl + k`: Resize increase up
- `Cmd + Ctrl + l`: Resize increase right

#### Pane Management
- `Cmd + d`: New pane (split right)
- `Cmd + Shift + d`: New pane (split down)
- `Cmd + Shift + w`: Close focused pane

#### Pane Movement
- `Cmd + Shift + h`: Move pane left
- `Cmd + Shift + j`: Move pane down
- `Cmd + Shift + k`: Move pane up
- `Cmd + Shift + l`: Move pane right

#### Pane Display
- `Cmd + f`: Toggle pane fullscreen (zoom / unzoom)
- `Cmd + z`: Toggle pane frames (stack view)

#### Legend
zoom = focused pane takes full tab size but layout is preserved
stack view = borders hidden so panes appear overlapped

- `Cmd + Shift + t`: New Ghostty tab (handled by Ghostty)
- `Cmd + t`: New Zellij tab/session (passed through to Zellij)
- `Cmd + d`: New Zellij pane split right (passed through to Zellij)
- `Cmd + Shift + d`: New Zellij pane split down (passed through to Zellij)
- `Cmd + Ctrl + Shift + Left/Right`: Move Ghostty tab left/right (handled by Ghostty)
- `Cmd + Ctrl + Shift + h/l`: Move Zellij tab left/right (passed through to Zellij)

#### Session Management
- `Ctrl + o` + `w`: Open session-manager

#### Mode Switching
- `Ctrl + a`: Switch to Tmux mode
- `Ctrl + g`: Switch to Locked mode
- `Ctrl + ;`: Switch to Scroll mode
- `Ctrl + g`: Switch back to Normal mode

## Integration Notes
- Ghostty unbinds `Ctrl + hjkl` so they pass through to Zellij
- All other Zellij keybinds work normally alongside default Zellij functionality
- System copy/paste (`Cmd + C/V`) still works in Ghostty
- Ghostty window management uses `Cmd + Shift` combinations to avoid conflicts

## AeroSpace Configuration (macOS tiling WM)

```
# Basic navigation
cmd+opt+h                   focus left
cmd+opt+j                   focus down
cmd+opt+k                   focus up
cmd+opt+l                   focus right

# Move active window
cmd+opt+shift+h             move window left
cmd+opt+shift+j             move window down
cmd+opt+shift+k             move window up
cmd+opt+shift+l             move window right

# Quick splits for current window
cmd+opt+v                   join-with right   # side-by-side
cmd+opt+b                   join-with down    # stacked

# Toggle last two focused windows
cmd+opt+tab                 focus-back-and-forth
```

## Hammerspoon (App Switching)

```
# Quick app switching
ctrl+shift+1                Ghostty
ctrl+shift+2                Arc
ctrl+shift+3                Obsidian
ctrl+shift+4                Sublime Text
```

