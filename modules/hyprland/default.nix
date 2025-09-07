{ config, pkgs, lib, ... }:

{
  imports = [
    ./config.nix    # Hyprland configuration settings
    ./binds.nix     # Keyboard and mouse bindings
    ./rules.nix     # Window rules and layerrules
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    xwayland.enable = true;
  };

  # Install necessary packages for the Hyprland environment
  home.packages = with pkgs; [
    waybar           # Status bar
    dunst            # Notification daemon
    libnotify        # Notification library
    swww             # Wallpaper daemon
    wl-clipboard     # Clipboard manager
    grim             # Screenshot utility
    slurp            # Screen region selection
    brightnessctl    # Brightness control
    pamixer          # Volume control
    networkmanagerapplet # Network manager tray
  ];
}
