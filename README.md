
# NixOS Cyberpunk Configuration

A modular, cyberpunk-themed configuration for NixOS with Hyprland, focusing on aesthetics and functionality.

![Cyberpunk Desktop](https://raw.githubusercontent.com/user/repo/main/screenshots/desktop.png)
*Screenshot placeholder - replace with your actual desktop*

## Overview

This repository contains my personal NixOS configuration with a strong focus on creating a cohesive cyberpunk aesthetic and a fully modular organization. It uses Home Manager for user-specific configurations and flakes for reproducibility.

The system is built around:
- Hyprland as the Wayland compositor
- Rofi with a custom cyberpunk theme
- Helix as the primary editor
- Custom shell configuration with Zsh and Starship
- A developing centralized theme system

## Structure

The configuration is organized as follows:

```
nixos-config/
├── flake.nix                  # Main entry point for configuration
├── configuration.nix          # System-wide configuration
├── home.nix                   # User-specific configuration (Home Manager)
└── modules/                   # Modular configuration components
    ├── development/           # Development environment
    ├── editors/               # Editor configurations (Helix)
    ├── hyprland/              # Hyprland and window management
    ├── rofi/                  # Application launcher
    ├── waybar/                # Status bar
    ├── yazi/                  # File manager
    ├── zellij/                # Terminal multiplexer
    └── zsh/                   # Shell configuration
```

## Features

### 🎮 Cyberpunk Theme

The configuration features a consistent cyberpunk theme with:
- Deep blue backgrounds (`#091833`)
- Neon cyan accents (`#0abdc6`)
- Neon magenta highlights (`#ea00d9`)
- Clean, modern typography using JetBrainsMono Nerd Font

### 🧩 Modular Design

Each component is isolated into its own module for easier:
- Maintenance
- Reuse
- Debugging
- Documentation

### 💻 Development Environment

Optimized for development with:
- Language-specific configurations (Rust, Go)
- LSP integration
- OpenSSL development headers properly configured
- Common development tools

### 🚀 Hyprland Configuration

A modern Wayland setup with:
- Efficient keybindings
- Workspace management
- Animation and styling
- Window rules for specific applications

## Current Status

Currently, this configuration implements:
- ✅ Basic system with Hyprland
- ✅ Rofi with cyberpunk theme
- ✅ Waybar integration
- ✅ Helix editor setup
- ✅ Development environment
- ✅ Zsh and Starship configuration
- 🔄 In progress: Centralized theme system

## Roadmap

### Next: Centralized Theme System

I'm currently working on a Tailwind-inspired theme system that will serve as a single source of truth for styling across all applications.

**Key features:**
- Central color definitions with semantic mappings
- Typography system
- Spacing and layout variables
- Consistent styling across all applications

The theme system will be implemented as a NixOS module that other modules can import and use for consistent styling.

### Future: Iconify for Nix

The next major project will be developing an icon management system for NixOS called "nix-iconify."

**Key features:**
- Declarative, reproducible icon management
- Integration with popular applications (Waybar, Rofi, etc.)
- Consistent iconography across different UI toolkits
- Prebundled icons with minimal external API usage
- Cross-distro compatibility

## Installation

This configuration is primarily for personal use and reference, but you can adapt it by:

1. Clone the repository:
```bash
git clone https://github.com/yourusername/nixos-config.git
```

2. Modify `configuration.nix` and `hardware-configuration.nix` for your system

3. Rebuild NixOS with your modified configuration:
```bash
sudo nixos-rebuild switch --flake .#nixos-framework
```

## Design Philosophy

This configuration is built with several core principles in mind:

1. **Modularity First**: Each component is isolated for better maintainability

2. **Consistency Matters**: Visual and functional consistency across the entire system

3. **Declarative Configuration**: Everything is explicitly defined for reproducibility

4. **Developer-Focused**: Optimized for software development workflows

5. **Aesthetics + Function**: A beautiful system that also enhances productivity

## Contributing

While this is my personal configuration, ideas and improvements are welcome:

- Open an issue for suggestions
- Submit a PR for bug fixes or enhancements
- Share your own configurations for inspiration

## Acknowledgments

- [NixOS](https://nixos.org/) for the incredible OS
- [Home Manager](https://github.com/nix-community/home-manager) for user configuration
- [Hyprland](https://hyprland.org/) for the compositor
- [Iconify](https://iconify.design/) for icon inspiration
- The cyberpunk aesthetic for visual inspiration

## License

This configuration is shared under the MIT license. Feel free to adapt it for your own use.
