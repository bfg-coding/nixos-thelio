{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Define the mod key ($mod)
    "$mod" = "SUPER";

    # Application bindings
    bind = [
      # Terminal
      "$mod, T, exec, ${pkgs.ghostty}/bin/ghostty"

      # File manager
      "$mod, F, exec, ${pkgs.cosmic-files}/bin/cosmic-files"
      "$mod, SHIFT F, exec, ${pkgs.yazi}/bin/yazi"

      # Lockscreen
      "$mod, ESCAPE, exec, ~/.local/bin/lock-screen-fancy" # SUPER + Escape to lock
      "$mod SHIFT, ESCAPE, exec, ~/.local/bin/lock-screen-fast" # SUPER + SHIFT + L for system lock

      # Quick lock with Ctrl+Alt+L (familiar from other DEs)
      "CTRL ALT, L, exec, ~/.local/bin/lock-screen-fast"

      # Window management
      "$mod, Q, killactive,"
      "$mod, M, exit,"
      "$mod, V, togglefloating,"
      "$mod, Z, fullscreen,"

      # ENTER MOVE MODE - Like Cosmic's Mod+Enter (with visual feedback)
      "$mod, Return, exec, hyprctl --batch 'keyword general:col.active_border rgba(ea00d9ee); dispatch submap move'"

      # Window focus
      "$mod, left, movefocus, l"
      "$mod, h, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, l, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, k, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, j, movefocus, d"

      # Workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Shift workspace
      "$mod CONTROL, h, workspace, m-1"
      "$mod CONTROL, l, workspace, m+1"

      # Shift windwo workspace
      "$mod SHIFT, h, movetoworkspace, r-1"
      "$mod SHIFT, l, movetoworkspace, r+1"

      # Move windows to workspaces
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Window stacking
      "$mod, S, togglegroup"

      # Add adjacent windows to current group
      "$mod ALT, H, changegroupactive, f" # Next window in stack
      "$mod ALT, L, changegroupactive, b" # Previous window in stack
      "$mod ALT, K, moveintogroup, u" # Add window above to group
      "$mod ALT, J, moveintogroup, d" # Add window below to group

      # Screenshot bindings
      ", PRINT, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

      # Volume control
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86AudioMute, exec, pamixer -t"

      # Brightness control
      ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];

    # Special bind for just the SUPER key (like Cosmic!)
    bindr = [
      "SUPER, Super_L, exec, rofi -theme cyberpunk -show drun"
    ];

    # Mouse bindings
    bindm = [
      # Move/resize windows with mod key + LMB/RMB drag
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };

  # MOVE MODE SUBMAP - Submaps need to be in extraConfig for Home Manager
  wayland.windowManager.hyprland.extraConfig = ''
    # Move mode submap (like Cosmic's window movement mode)
    submap = move
    
    # Move window in different directions
    bind = , h, movewindow, l
    bind = , left, movewindow, l
    bind = , j, movewindow, d
    bind = , down, movewindow, d
    bind = , k, movewindow, u
    bind = , up, movewindow, u
    bind = , l, movewindow, r
    bind = , right, movewindow, r
    
    # Alternative: Swap instead of move (with Shift)
    bind = SHIFT, h, swapwindow, l
    bind = SHIFT, j, swapwindow, d
    bind = SHIFT, k, swapwindow, u
    bind = SHIFT, l, swapwindow, r
    
    # Resize while in move mode (with Ctrl)
    bind = CTRL, h, resizeactive, -50 0
    bind = CTRL, l, resizeactive, 50 0
    bind = CTRL, k, resizeactive, 0 -50
    bind = CTRL, j, resizeactive, 0 50
    
    # Exit move mode (reset border color and exit submap)
    bind = , escape, exec, hyprctl --batch 'keyword general:col.active_border rgba(33ccffee); dispatch submap reset'
    bind = , Return, exec, hyprctl --batch 'keyword general:col.active_border rgba(33ccffee); dispatch submap reset'
    bind = , q, exec, hyprctl --batch 'keyword general:col.active_border rgba(33ccffee); dispatch submap reset'
    
    # Reset submap (return to global)
    submap = reset
  '';
}
