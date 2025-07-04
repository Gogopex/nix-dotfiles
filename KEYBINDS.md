## Modifier Hierarchy

Scope-based hierarchy from smallest to largest operational scope:

1. **Ctrl**: Terminal/pane navigation (within terminal)
2. **Cmd**: Tab/session operations (within application)  
3. **Cmd+Opt**: Window manager operations (across applications)
4. **Ctrl+Shift**: Application switching (system-level shortcuts)

### Modifier Combination Patterns
- **Base modifier**: Basic operation (focus, navigate)
- **+ Shift**: Destructive/moving operations (close, move, split down)
- **+ Ctrl**: Resizing operations  
- **+ Alt**: Search/utility operations 

### Ergonomic Notes
- **Cmd+Opt access**: Use ZSA Voyager's "Cmd" and "Opt" keys for window management

## Ghostty Configuration

Ghostty is configured to handle its own tab management while passing through pane/session management to Zellij:

```
# Ghostty tab management
keybind = cmd+shift+t=new_tab
# Pass through to Zellij for pane navigation
# Pass through to Zellij for tab navigation
# Pass through to Zellij for pane splitting
# Pass through to Zellij for pane resizing
# Pass through to Zellij for tab reordering
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

#### Stacked Panes Management
- `Cmd + b`: Next swap layout (cycle through layouts including stacked)
- `Cmd + Shift + b`: Previous swap layout (reverse cycle)

#### Tab Movement
- `Opt + i`: Move tab left
- `Opt + o`: Move tab right

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
- Ghostty window management uses `Cmd + Shift` combinations to avoid conflicts

## AeroSpace Configuration (macOS tiling WM)

**Layout**: Automatic 2x2 grid arrangement - windows arrange optimally from 1 (fullscreen) to 4 (2x2 grid)
**Two-tier hierarchy:** `Cmd + Opt + hjkl` for frequent operations, `Cmd + Opt + Shift + right-hand keys` for less frequent

#### Frequent Operations (Cmd + Opt + hjkl)
- `Cmd + Opt + h`: Focus left
- `Cmd + Opt + j`: Focus down
- `Cmd + Opt + k`: Focus up
- `Cmd + Opt + l`: Focus right

#### Window Movement (Cmd + Opt + Shift + hjkl)
- `Cmd + Opt + Shift + h`: Move window left
- `Cmd + Opt + Shift + j`: Move window down
- `Cmd + Opt + Shift + k`: Move window up
- `Cmd + Opt + Shift + l`: Move window right

#### Less Frequent Operations (Cmd + Opt + Shift + right-hand keys)

**Window Resizing:**
- `Cmd + Opt + Shift + u`: Resize smart -50
- `Cmd + Opt + Shift + i`: Resize smart +50

**Window Splits:**
- `Cmd + Opt + Shift + y`: Join with right (side-by-side)
- `Cmd + Opt + Shift + o`: Join with down (stacked)

**Layout Management:**
- `Cmd + Opt + Shift + n`: Toggle floating/tiling
- `Cmd + Opt + Shift + m`: Tiles (default tiling layout)

**Focus Management:**
- `Cmd + Opt + Shift + p`: Focus back-and-forth (toggle last two windows)

## Terminal Output & Link Management

### Direct Scrollback Editing
- `Ctrl + Shift + e`: Open current terminal scrollback directly in Helix (no scroll mode needed)

### Fish Vi Mode for Terminal Navigation
- `Ctrl + ;`: Toggle between vi mode and default mode

#### Vi Mode Keybinds
- **Standard navigation**: `h/j/k/l`, `w/b/e`, `/` for search, `y` to yank, etc.
- **Line selection**: `Shift + V` - visual select entire line
- **Line navigation**: 
  - `gh` - go to beginning of line (like `0` or `^`)
  - `gl` - go to end of line (like `$`)
- **Buffer navigation**:
  - `gg` - go to beginning of command history buffer  
  - `G` - go to end of command history buffer
- **Mode switching**: `Escape` or `Ctrl + c` - switch between insert/normal mode

### Link Extraction
- `Ctrl + Alt + l`: Extract URLs from current Zellij pane scrollback and open with fzf selection
- `links`: Command alias for URL extraction (same as Ctrl+Alt+l)

## Fish Shell & FZF Integration

### FZF Keybindings 
- `Ctrl + Alt + f`: Search files and directories with fzf
- `Ctrl + Alt + l`: **Search Git Log** 
- `Ctrl + Alt + s`: **Search Git Status** 
- `Ctrl + r`: Search command history with fzf
- `Ctrl + Alt + p`: Search running processes with fzf
- `Ctrl + v`: Search shell variables with fzf
- `Ctrl + Alt + v`: Toggle vim mode in Fish shell
- `Ctrl + Alt + l`: Open links from Zellij scrollback with fzf selection
- `Ctrl + ;`: Toggle between vi mode and default mode

## Hammerspoon (App Switching)

- `Ctrl + Shift + 1`: Ghostty
- `Ctrl + Shift + 2`: Arc
- `Ctrl + Shift + 3`: Obsidian
- `Ctrl + Shift + 4`: Sublime Text

