# Agent Configuration

## Build/Test Commands
- `darwin-rebuild switch --flake .#macbook` - Build and apply system configuration
- `nix flake check` - Check flake configuration for syntax errors
- `nix build .#darwinConfigurations.macbook.system` - Build system without applying
- `nix-collect-garbage -d` - Clean up old generations

## Architecture
This is a **Nix Darwin** dotfiles repository for macOS system configuration using flakes.
- `flake.nix` - Main flake with system configuration for macbook host
- `hosts/macbook/darwin.nix` - Host-specific Darwin configuration  
- `cfg/` - Application configuration files (ghostty, nvim, hammerspoon, etc.)
- `modules/obsidian.nix` - Custom Nix modules for applications
- `secrets/` - Age-encrypted secrets (API keys)

## Code Style
- Use **nixfmt-rfc-style** for Nix code formatting
- Follow existing patterns in flake.nix for adding packages/programs
- Configuration files in `cfg/` maintain their native formats (KDL for Zellij, Lua for Hammerspoon, etc.)
- Use `let...in` blocks for complex configurations
- Comment rationale for complex keybindings or workarounds

## Key Tools
- Primary editors: Helix (`hx`), Zed, Neovim
- Terminal: Ghostty with Zellij session manager
- Shell: Fish with Zoxide for directory navigation
- Version control: Jujutsu (`jj`) and Git
