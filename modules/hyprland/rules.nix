{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Window rules
    windowrule = [
      # Firefox Picture-in-Picture always on top
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # Media viewers as floating windows
      "float, class:^(imv)$"
      "float, class:^(mpv)$"

      # Image viewers centered with specific size
      "center, class:^(imv)$"
      "size 75% 75%, class:^(imv)$"

      # File browsers with specific opacity
      "opacity 0.95, class:^(thunar)$"
      "opacity 0.95, class:^(nautilus)$" # GNOME file manager

      # Notifications on specific workspace
      "workspace special silent, title:^(.*Notification.*)$"

      # File browsers with specific opacity and workspace
      "opacity 0.95, class:^(thunar)$"
      "opacity 0.98, class:^(cosmic-files)$" # Cosmic Files with slight transparency
      "workspace 3, class:^(cosmic-files)$" # Auto-assign to workspace 3 (Files)

      # Dialog windows floating
      "float, title:^(.*Dialog.*)$"
      "float, title:^(.*Settings.*)$"

      # IDEs
      "opacity 0.98, class:^(code)$"
      "opacity 0.98, class:^(dev.zed.Zed)$"

      # Socials
      "opacity 0.98, class:^(vesktop)$"
      "opacity 0.98, class:^(Signal)$"

      # Cross-desktop applications (when launched from Hyprland)
      "opacity 0.98, class:^(cosmic-edit)$"
      "opacity 0.95, class:^(cosmic-term)$"
      "opacity 0.95, class:^(gnome-terminal)$"

      # Ensure Obsidian appears where you expect
      "workspace 4, class:^(obsidian)$" # Put it on primary monitor
      "center, class:^(obsidian)$"
      "opacity 0.98, class:^(obsidian)$"
    ];

    # Layer rules for proper blur and transparency
    layerrule = [
      "blur, rofi"
      "blur, waybar"
      "blur, class:^(.*ghostty.*)$"
    ];

    # Window rules v2 (more specific/advanced rules)
    windowrulev2 = [
      # Terminal opacity settings (consolidated here)
      "opacity 0.95, class:^(.*ghostty.*)$"
      "opacity 0.95, class:^(kitty)$"
      "opacity 0.95, class:^(alacritty)$"

      # Rofi specific rules
      "noborder, class:^(rofi)$"

      # Ensure desktop environment settings apps float
      "float, class:^(cosmic-settings)$"
      "float, class:^(gnome-control-center)$"
      "center, class:^(cosmic-settings)$"
      "center, class:^(gnome-control-center)$"

      # Cosmic Files specific rules for better integration
      "opacity 0.98, class:^(cosmic-files)$"
      "size 75% 75%, class:^(cosmic-files)$, floating:1" # Good size when floating
      "center, class:^(cosmic-files)$, floating:1" # Center when floating

      # PLAYWRIGHT UI RULES - More specific matching
      # These will override any default floating behavior
      "tile, title:^(.*Playwright.*)"
      "tile, title:^(.*Test Runner.*)"
      "tile, title:^(.*localhost.*), class:^(chromium.*)"
      "tile, title:^(.*127.0.0.1.*), class:^(chromium.*)"
      "workspace 2, title:^(.*Playwright.*)" # Development workspace
      "opacity 0.98, title:^(.*Playwright.*)" # Slight transparency
    ];
  };
}
