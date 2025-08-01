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

#### Swap Layouts (Pane Arrangements)
- `Cmd + b`: Next swap layout (cycle through vertical, horizontal, and stacked layouts)
- `Cmd + Shift + b`: Previous swap layout (reverse cycle)
- `Cmd + e`: Toggle pane embed or floating

Available swap layouts:
- **vertical**: Panes arranged in vertical columns
- **horizontal**: Panes arranged in horizontal rows  
- **stacked**: Panes stacked on top of each other (requires 5+ panes)

#### Tab Movement
- `Opt + i`: Move tab left
- `Opt + o`: Move tab right

#### Session Management
- `Cmd + s` then `w`: Open session-manager

#### Mode Switching
- `Ctrl + a`: Switch to Tmux mode
- `Ctrl + g`: Switch to Locked mode
- `Ctrl + ;`: Switch to Scroll mode
- `Ctrl + g`: Switch back to Normal mode

#### Legend
- **zoom**: Focused pane takes full tab size but layout is preserved
- **stack view**: Borders hidden so panes appear overlapped

## Integration Notes
- Ghostty window management uses `Cmd + Shift` combinations to avoid conflicts

## AeroSpace Configuration (macOS tiling WM)

### Window Mode Entry
- `Alt + w`: Enter Window mode (all operations)

### Window Mode Operations (Alt + w, then...)

**Focus Navigation:**
- `h/j/k/l`: Focus left/down/up/right window
- `\`: Focus back and forth between windows

**Move Windows:**
- `Shift + h/j/k/l`: Move window left/down/up/right

**Layout Management:**
- `e`: Join with up and set v_accordion layout
- `t`: Set tiles layout
- `/`: Toggle between tiles horizontal and vertical
- `,`: Toggle between accordion horizontal and vertical
- `Shift + f`: Toggle between floating and tiling

**Window Resizing:**
- `i`: Increase window size (+50 pixels smart resize)
- `o`: Decrease window size (-50 pixels smart resize)
- `Shift + b`: Balance window sizes

**Workspace Navigation:**
- `1`: Switch to workspace 1
- `2`: Switch to workspace 2
- `Shift + 1`: Move window to workspace 1
- `Shift + 2`: Move window to workspace 2

**Window Management:**
- `f`: Toggle fullscreen
- `c`: Close window
- `Shift + r`: Flatten workspace tree

**Exit:** `Escape`, `Enter`, or `Alt + w`

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

### FZF Keybindings (fzf.fish plugin defaults)
- `Ctrl + Alt + f`: Search files and directories with fzf
- `Ctrl + Alt + s`: Search Git status with fzf
- `Ctrl + r`: Search command history with fzf
- `Ctrl + Alt + p`: Search running processes with fzf
- `Ctrl + v`: Search shell variables with fzf

### Custom Fish Keybindings
- `Ctrl + Alt + v`: Toggle vim mode in Fish shell
- `Ctrl + Alt + l`: Open links from Zellij scrollback with fzf selection (overrides default Git log search)
- `Ctrl + ;`: Toggle between vi mode and default mode
- `Ctrl + Alt + b`: Launch broot file manager

## Broot File Manager

### Navigation (Modal)
- `h/j/k/l`: Navigate files (left/down/up/right)
- `Enter`: Open directory or file
- `Escape`: Go back/cancel

### Commands
- `e`: Edit file in $EDITOR
- `v`: View file with bat
- `c`: Create new file
- `cd`: Change directory (quit broot and cd to selected directory)

### Aliases
- `br`: Shell function that properly handles broot's directory changes

## Helix Editor

### File Operations
- `Space y p`: Copy full absolute path of current buffer to clipboard
- `Space y g`: Copy GitHub link of current file with line number to clipboard

## Hammerspoon (App Switching)

- `Shift + Ctrl + Alt + Cmd + 1`: Ghostty
- `Shift + Ctrl + Alt + Cmd + 2`: Arc
- `Shift + Ctrl + Alt + Cmd + 3`: Obsidian
- `Shift + Ctrl + Alt + Cmd + 4`: Sublime Text

