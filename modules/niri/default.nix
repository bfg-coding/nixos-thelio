{ config, pkgs, lib, stylesheet, inputs ? null, ... }:

{
  imports = [
    ./config.nix # Core Niri configuration
    ./binds.nix # Keybindings
    ./rules.nix # Window rules
  ];

  # Essential Niri packages
  home.packages = with pkgs; [
    # Core Niri functionality
    niri
    xwayland-satellite # X11 app support

    # Wallpaper (same as Hyprland)
    swww

    # Launcher
    fuzzel # Niri's default, but you can use rofi too

    # Screenshot tools (same as Hyprland)
    grim
    slurp

    # Notification daemon (reuse from Hyprland)
    # dunst is already in your packages

    # Optional: Niri-specific utilities
    # wl-clipboard is already in your packages
  ];

  # Niri will use your existing services
  # These are already configured in your home.nix:
  # - services.dunst (notifications)
  # - programs.waybar (status bar)
  # - services.swaylock (lock screen)

  # Rofi works in Niri too (reuse your cyberpunk theme!)
  # No additional config needed
}
