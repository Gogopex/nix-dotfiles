## Modifier Hierarchy

Scope-based hierarchy from smallest to largest operational scope:

1. **Ctrl**: Terminal/pane navigation (smallest scope - within terminal)
2. **Cmd**: Tab/session operations (medium scope - within application)  
3. **Cmd+Opt**: Window manager operations (largest scope - across applications)
4. **Ctrl+Shift**: Application switching (system-level shortcuts)

### Modifier Combination Patterns
- **Base modifier**: Basic operation (focus, navigate)
- **+ Shift**: Destructive/moving operations (close, move, split down)
- **+ Ctrl**: Resizing operations  
- **+ Alt**: Search/utility operations (FZF functions)

### Ergonomic Notes
- **Cmd+Opt access**: Use ZSA Voyager's "Cmd" and "Opt" keys for window management
- **Consistent directional keys**: `h/j/k/l` used across all hierarchy levels
- **Native macOS**: `Cmd+Tab` preserved for native app switching

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
- Ghostty unbinds `Ctrl + hjkl` so they pass through to Zellij
- All other Zellij keybinds work normally alongside default Zellij functionality
- System copy/paste (`Cmd + C/V`) still works in Ghostty
- Ghostty window management uses `Cmd + Shift` combinations to avoid conflicts

## AeroSpace Configuration (macOS tiling WM)

**Native macOS Integration**: `Cmd + Tab` works as native macOS app switcher (AeroSpace doesn't intercept it)

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
- **Enhanced Fish vi mode is enabled by default**
- `Ctrl + ;`: Toggle between vi mode and default mode

#### Enhanced Vi Mode Keybinds
- **Standard navigation**: `h/j/k/l`, `w/b/e`, `/` for search, `y` to yank, etc.
- **Line selection**: `Shift + V` - visual select entire line
- **Line navigation**: 
  - `gh` - go to beginning of line (like `0` or `^`)
  - `gl` - go to end of line (like `$`)
- **Buffer navigation**:
  - `gg` - go to beginning of command history buffer  
  - `G` - go to end of command history buffer
- **Mode switching**: `Escape` or `Ctrl + c` - switch between insert/normal mode

#### Benefits of Enhanced Vi Mode
- **Familiar keybinds**: `gh`/`gl` mirror vim's line navigation philosophy
- **Visual selection**: `Shift + V` for quick line selection and editing
- **Buffer navigation**: `gg`/`G` for command history browsing
- **Works in visual mode**: All navigation keys work in both normal and visual modes

### Link Extraction
- `Ctrl + Alt + l`: Extract URLs from current Zellij pane scrollback and open with fzf selection
- `links`: Command alias for URL extraction (same as Ctrl+Alt+l)

### Benefits of New Workflow
- **Direct Helix access**: No need to enter/exit scroll mode
- **Native vi navigation**: Fish's built-in vi mode is more responsive and familiar
- **Accurate link extraction**: Uses Zellij's `dump-screen` to get actual pane content
- **Better ergonomics**: Single keybind workflows, vi mode by default
- **Consistent experience**: Works seamlessly with your Zellij-centric workflow

## Fish Shell & FZF Integration

### FZF Keybindings (Available in both default and insert modes)
- `Ctrl + Alt + f`: Search files and directories with fzf
- `Ctrl + Alt + l`: **Search Git Log** - Interactive git history browser with commit preview
- `Ctrl + Alt + s`: **Search Git Status** - Interactive git status browser with file diff preview
- `Ctrl + r`: Search command history with fzf
- `Ctrl + Alt + p`: Search running processes with fzf
- `Ctrl + v`: Search shell variables with fzf

### Custom Fish Keybindings
- `Ctrl + Alt + v`: Toggle vim mode in Fish shell
- `Ctrl + Alt + l`: Open links from Zellij scrollback with fzf selection
- `Ctrl + ;`: Toggle between vi mode and default mode

## Hammerspoon (App Switching)

- `Ctrl + Shift + 1`: Ghostty
- `Ctrl + Shift + 2`: Arc
- `Ctrl + Shift + 3`: Obsidian
- `Ctrl + Shift + 4`: Sublime Text

