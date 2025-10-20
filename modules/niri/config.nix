{ config, pkgs, lib, stylesheet, ... }:

{
  # If using nixpkgs niri (not niri-flake), configure via KDL file
  xdg.configFile."niri/config.kdl".text = ''
    // Niri Configuration
    // Using Tokyo Night colors from CrystalNix
    
    // ============================================
    // INPUT CONFIGURATION
    // ============================================
    
    input {
        keyboard {
            xkb {
                layout "us"
            }
            
            // Repeat rate (matches typical settings)
            repeat-delay 600
            repeat-rate 25
        }
        
        touchpad {
            tap
            natural-scroll
            dwt  // disable-while-typing
            click-method "clickfinger"
        }
        
        mouse {
            accel-profile "flat"
            accel-speed 0.5
        }
        
        // Disable trackpoint if you have one
        // trackpoint {
        //     accel-profile "flat"
        // }
    }
    
    // ============================================
    // OUTPUT CONFIGURATION (Your monitors)
    // ============================================
    
    output "eDP-1" {
        mode "2256x1504@60"
        position x=0 y=0
        scale 1.0
    }
        
    // ============================================
    // LAYOUT CONFIGURATION
    // ============================================
    
    layout {
        // Gaps between windows (using design system)
        gaps ${toString stylesheet.spacing.sm.raw}
        
        // Keep active column in center or on the left
        center-focused-column "never"
        
        // Preset column widths for quick cycling
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        
        // Default width for new columns
        default-column-width { proportion 0.5 }
        
        // Column expansion behavior
        // Options: "resize-window" or "center-column"
        focus-ring {
            off
        }
        
        border {
            off
        }
        
        // Struts (space reserved for panels like waybar)
        struts {
            left 0
            right 0
            top 30    // Space for waybar
            bottom 0
        }
    }
    
    // ============================================
    // PREFER NO CLIENT-SIDE DECORATIONS
    // ============================================
    
    prefer-no-csd
    
    // ============================================
    // CURSOR CONFIGURATION
    // ============================================
    
    cursor {
        xcursor-theme "Adwaita"
        xcursor-size 24
    }
    
    // ============================================
    // SPAWN AT STARTUP
    // ============================================
    
    spawn-at-startup "waybar"
    spawn-at-startup "dunst"
    spawn-at-startup "xwayland-satellite"
    
    // Wallpaper using swww (same as Hyprland)
    spawn-at-startup "swww-daemon"
    // You'll need to set wallpaper manually after login:
    // swww img /path/to/your/wallpaper.jpg
    
    // ============================================
    // WINDOW RULES (Tokyo Night themed)
    // ============================================
    
    window-rule {
        // Terminal opacity
        match app-id="^ghostty$"
        match app-id="^kitty$"
        match app-id="^[Aa]lacritty$"
        
        opacity 0.95
    }
    
    window-rule {
        // Code editors
        match app-id="^code$"
        match app-id="^zed$"
        
        opacity 0.98
    }
    
    window-rule {
        // Cosmic Files
        match app-id="^com\\.system76\\.CosmicFiles$"
        
        opacity 0.98
    }
    
    window-rule {
        // Browsers
        match app-id="^firefox$"
        match app-id="^brave-browser$"
        match app-id="^zen-browser$"
        
        opacity 1.0
    }
    
    window-rule {
        // Floating windows
        match title="^(.*)[Dd]ialog(.*)$"
        match title="^(.*)[Ss]ettings(.*)$"
        
        default-column-width { proportion 0.4 }
    }
    
    // JetBrains IDEs
    window-rule {
        match app-id="^jetbrains-(.*)$"
        
        opacity 0.98
    }
    
    // ============================================
    // ANIMATIONS (Tokyo Night inspired - snappy)
    // ============================================
    
    animations {
        // Window open/close
        window-open {
            duration-ms ${toString (stylesheet.motion.duration.normal.raw)}
            curve "ease-out-cubic"
        }
        
        window-close {
            duration-ms ${toString (stylesheet.motion.duration.fast.raw)}
            curve "ease-in-cubic"
        }
        
        // The key animation: horizontal scrolling
        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        // Workspace switching (vertical)
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }
        
        // Window movement in layout
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        // Window resize
        window-resize {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        // Config reload
        config-notification-open-close {
            spring damping-ratio=0.6 stiffness=1000 epsilon=0.001
        }
    }
    
    // ============================================
    // SCREENSHOT CONFIGURATION
    // ============================================
    
    screenshot-path "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png"
    
    // ============================================
    // HOTKEY OVERLAYS
    // ============================================
    
    // Show on-screen display for mode changes
    // hotkey-overlay {
    //     skip-at-startup
    // }
    
    // ============================================
    // DEBUG OPTIONS (useful during testing)
    // ============================================
    
    debug {
        // Uncomment to see frame times
        // render-drm-device "/dev/dri/renderD128"
        
        // Uncomment to disable direct scanout
        // disable-direct-scanout
        
        // Wait for frame completion (more latency, smoother)
        // wait-for-frame-completion-before-queueing
        
        // Enable damage tracking visualization
        // damage "all"
        
        // Show FPS overlay
        // dbus-interfaces-in-non-session-instances
    }
  '';

  # Create wallpaper setter script for Niri
  home.file.".local/bin/niri-set-wallpaper" = {
    text = ''
      #!/usr/bin/env bash
      # Set wallpaper in Niri using swww
      
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
      
      if [ -z "$1" ]; then
          # No argument, use random wallpaper
          if [ -d "$WALLPAPER_DIR" ]; then
              WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)
          else
              echo "Wallpaper directory not found: $WALLPAPER_DIR"
              exit 1
          fi
      else
          WALLPAPER="$1"
      fi
      
      if [ -f "$WALLPAPER" ]; then
          ${pkgs.swww}/bin/swww img "$WALLPAPER" --transition-type fade --transition-duration 1
          echo "Wallpaper set: $WALLPAPER"
      else
          echo "Wallpaper not found: $WALLPAPER"
          exit 1
      fi
    '';
    executable = true;
  };

  # Niri session script to set up environment
  home.file.".local/bin/niri-session-setup" = {
    text = ''
      #!/usr/bin/env bash
      # Run this after logging into Niri to set up your environment
      
      # Wait a bit for Niri to fully start
      sleep 2
      
      # Set wallpaper
      ~/.local/bin/niri-set-wallpaper
      
      # Optional: Start any additional services not in spawn-at-startup
      # (Most are already handled by systemd user services)
      
      echo "Niri session setup complete!"
    '';
    executable = true;
  };
}
