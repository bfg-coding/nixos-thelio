{ config, pkgs, lib, stylesheet, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration
    monitor = ",preferred,auto,1";

    # Environment variables
    env = [
      # Set cosmic-files as the default file manager
      "FILE_MANAGER,cosmic-files"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
    ];

    # Workspace assignments to monitors
    workspace = [
      # Primary workspaces on main monitor (DP-5 - your ultrawide)
      "1, monitor:DP-2, default:true"
      "2, monitor:DP-2"
      "3, monitor:DP-2"
      "4, monitor:DP-2"
      "5, monitor:DP-2"

      # Secondary workspaces on second monitor (DP-4)
      "6, monitor:DP-3"
      "7, monitor:DP-3"
      "8, monitor:DP-3"
      "9, monitor:DP-3"
      "10, monitor:DP-3"
    ];

    # Execute applications at launch
    exec-once = [
      "dunst"
      "${pkgs.swww}/bin/swww init"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    ];

    # General settings
    general = {
      gaps_in = stylesheet.spacing.sm.raw;
      gaps_out = stylesheet.spacing.md.raw;
      border_size = stylesheet.borders.width.normal.raw;

      # Tokyo Night signature colors!
      "col.active_border" = "rgb(${stylesheet.colors.warning."500".conf})";
      "col.inactive_border" = "rgb(${stylesheet.colors.border.inactive.conf})";

      layout = "dwindle";
    };


    # Group (window stacking) configuration
    group = {
      "col.border_active" = "rgb(${stylesheet.colors.secondary."200".conf}) rgb(${stylesheet.colors.slate."800".conf}) 45deg"; # Gradient border for active group
      "col.border_inactive" = "rgb(${stylesheet.colors.border.inactive.conf})"; # Inactive group border
      "col.border_locked_active" = "rgb(${stylesheet.colors.error."500".conf})"; # Locked group active border
      "col.border_locked_inactive" = "rgba(${stylesheet.colors.error."500".conf}66)"; # Locked group inactive border

      groupbar = {
        enabled = true;
        font_size = stylesheet.typography.fontSize.sm.raw;
        font_family = stylesheet.typography.fontFamily.mono.single;
        gradients = true;
        height = stylesheet.spacing.lg.raw;
        priority = 3;
        render_titles = true;
        scrolling = true;
        text_color = "rgb(${stylesheet.colors.text.primary.conf})";
        "col.active" = "rgb(${stylesheet.colors.secondary."500".conf})"; # Active tab in group
        "col.inactive" = "rgba(${stylesheet.colors.text.secondary.conf}aa)"; # Inactive tab in group
        "col.locked_active" = "rgb(${stylesheet.colors.error."500".conf})";
        "col.locked_inactive" = "rgba(${stylesheet.colors.error."500".conf}66)";
      };
    };

    # Decoration settings
    decoration = {
      rounding = stylesheet.borders.radius.md.raw;
      blur = {
        enabled = true;
        size = 10;
        passes = 3;
        new_optimizations = true;
      };

      # Shadow configuration
      shadow = {
        enabled = true;
        range = 6;
        render_power = 3;
        color = "rgba(${stylesheet.colors.bg.primary.conf}ee)";
      };
    };

    # Animation settings
    animations = {
      enabled = true;

      # Tokyo Night's snappy feel
      bezier = [
        "tokyo, 0.4, 0, 0.2, 1" # Material Design inspired
        "smooth, 0.25, 0.46, 0.45, 0.94"
      ];

      animation = [
        # Faster animations for Tokyo Night's responsive feel
        "windows, 1, ${toString (stylesheet.motion.duration.normal.raw / 100)}, tokyo"
        "windowsOut, 1, ${toString (stylesheet.motion.duration.fast.raw / 100)}, tokyo, popin 80%"
        "border, 1, ${toString (stylesheet.motion.duration.fast.raw / 100)}, tokyo"
        "fade, 1, ${toString (stylesheet.motion.duration.normal.raw / 100)}, smooth"
        "workspaces, 1, ${toString (stylesheet.motion.duration.slow.raw / 100)}, tokyo"
      ];
    };

    # Layout settings
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    # Cursor settings
    cursor = {
      inactive_timeout = 5; # Hide cursor after 5 seconds of inactivity
    };

    # Input settings
    input = {
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = 0.5; # Mouse sensitivity (0.0 - 1.0)
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        tap-to-click = true;
      };
    };

    # Window rules & Layer rules
    layerrule = [
      "blur, rofi" # Apply blur to Rofi launcher
      "ignorezero, rofi" # Properly handle transparency
      "blur, waybar" # Apply blur to Waybar
    ];
  };
}
