{ config, pkgs, lib, ... }:

{
  xdg.configFile."niri/config.kdl".text = lib.mkAfter ''
    // ============================================
    // KEYBINDINGS
    // ============================================
    
    binds {
        // ============================================
        // SYSTEM & SESSION
        // ============================================
        
        // IMPORTANT: Exit Niri (Mod+Shift+E)
        Mod+Shift+E { quit; }
        
        // Lock screen (uses your swaylock config)
        Mod+Escape { spawn "${config.home.homeDirectory}/.local/bin/lock-screen-fancy"; }
        Mod+Shift+Escape { spawn "${config.home.homeDirectory}/.local/bin/lock-screen-fast"; }
        Ctrl+Alt+L { spawn "${config.home.homeDirectory}/.local/bin/lock-screen-fast"; }
        
        // ============================================
        // APPLICATION LAUNCHING
        // ============================================
        
        // Terminal
        Mod+T { spawn "${pkgs.ghostty}/bin/ghostty"; }
        
        // File manager
        Mod+F { spawn "${pkgs.cosmic-files}/bin/cosmic-files"; }
        
        // Launcher (using rofi with your cyberpunk theme)
        Mod+D { spawn "${pkgs.rofi-wayland}/bin/rofi" "-theme" "cyberpunk" "-show" "drun"; }
        
        // Alternative: Use fuzzel (Niri's default)
        // Super { spawn "${pkgs.fuzzel}/bin/fuzzel"; }
        
        // Browser
        Mod+B { spawn "${pkgs.brave}/bin/brave"; }
        
        // ============================================
        // WINDOW MANAGEMENT
        // ============================================
        
        // Close window
        Mod+Q { close-window; }
        
        // Fullscreen
        Mod+Z { fullscreen-window; }
        
        // ============================================
        // FOCUS MOVEMENT (The Magic of Scrollable Tiling!)
        // ============================================
        
        // Focus columns (horizontal scroll)
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        
        // Focus windows within column (vertical)
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }
        Mod+Up { focus-window-up; }
        Mod+Down { focus-window-down; }
        
        // Focus first/last window in column
        Mod+Home { focus-window-down-or-column-left; }
        Mod+End { focus-window-up-or-column-right; }
        
        // ============================================
        // WINDOW MOVEMENT
        // ============================================
        
        // Move columns
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        
        // Move windows within column
        Mod+Shift+K { move-window-up; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Down { move-window-down; }
        
        // Move to first/last position
        Mod+Shift+Home { move-window-to-column-start; }
        Mod+Shift+End { move-window-to-column-end; }
        
        // ============================================
        // COLUMN MANAGEMENT (Replaces Hyprland Stacking)
        // ============================================
        
        // Consume/expel windows (stack/unstack)
        Mod+BracketLeft { consume-window-into-column; }
        Mod+BracketRight { expel-window-from-column; }
        
        // Alternative with Comma/Period
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }
        
        // ============================================
        // COLUMN WIDTH CONTROL
        // ============================================
        
        // Cycle preset widths (33%, 50%, 66%)
        Mod+R { switch-preset-column-width; }
        
        // Manual width adjustment
        Mod+Minus { set-column-width "-10%"; }
        Mod+Plus { set-column-width "+10%"; }
        Mod+Equal { set-column-width "+10%"; }
        
        // Reset sizes
        Mod+Shift+R { reset-window-height; }
        
        // Maximize column
        Mod+M { maximize-column; }
        
        // ============================================
        // WORKSPACE MANAGEMENT (Vertical!)
        // ============================================
        
        // Jump to specific workspace
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        
        // Move up/down through workspaces
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up { focus-workspace-up; }
        
        // Move column to workspace
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        
        // Move column up/down
        Mod+Shift+U { move-column-to-workspace-down; }
        Mod+Shift+I { move-column-to-workspace-up; }
        Mod+Shift+Page_Down { move-column-to-workspace-down; }
        Mod+Shift+Page_Up { move-column-to-workspace-up; }
        
        // Move workspace between monitors
        Mod+Ctrl+H { move-workspace-to-monitor-left; }
        Mod+Ctrl+L { move-workspace-to-monitor-right; }
        Mod+Ctrl+Left { move-workspace-to-monitor-left; }
        Mod+Ctrl+Right { move-workspace-to-monitor-right; }
        
        // ============================================
        // MONITOR FOCUS
        // ============================================
        
        Mod+Shift+Ctrl+H { focus-monitor-left; }
        Mod+Shift+Ctrl+L { focus-monitor-right; }
        Mod+Shift+Ctrl+Left { focus-monitor-left; }
        Mod+Shift+Ctrl+Right { focus-monitor-right; }
        
        // ============================================
        // OVERVIEW MODE (The Killer Feature!)
        // ============================================
        
        // Show overview (all workspaces, all windows)
        Mod+Tab { show-overview; }
        
        // ============================================
        // MOUSE SCROLL BINDINGS
        // ============================================
        
        // Scroll through workspaces
        Mod+WheelScrollDown { focus-workspace-down; }
        Mod+WheelScrollUp { focus-workspace-up; }
        
        // Scroll through columns
        Mod+Shift+WheelScrollDown { focus-column-right; }
        Mod+Shift+WheelScrollUp { focus-column-left; }
        
        // Adjust column width with mouse
        Mod+Ctrl+WheelScrollDown { set-column-width "-10%"; }
        Mod+Ctrl+WheelScrollUp { set-column-width "+10%"; }
        
        // ============================================
        // SCREENSHOTS
        // ============================================
        
        Print { screenshot; }
        Shift+Print { screenshot-screen; }
        Ctrl+Print { screenshot-window; }
        
        // ============================================
        // VOLUME CONTROL (Same as Hyprland)
        // ============================================
        
        XF86AudioRaiseVolume { spawn "${pkgs.pamixer}/bin/pamixer" "-i" "5"; }
        XF86AudioLowerVolume { spawn "${pkgs.pamixer}/bin/pamixer" "-d" "5"; }
        XF86AudioMute { spawn "${pkgs.pamixer}/bin/pamixer" "-t"; }
        
        // ============================================
        // BRIGHTNESS CONTROL
        // ============================================
        
        XF86MonBrightnessUp { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-"; }
        
        // ============================================
        // POWER MANAGEMENT
        // ============================================
        
        // Quick power menu (reuse from Hyprland if you have one)
        // Mod+P { spawn "${pkgs.rofi-wayland}/bin/rofi" "-show" "power-menu"; }
    }
  '';
}
