# modules/terminal/ghostty.nix
{ pkgs, stylesheet, ... }:

{
  # Install Ghostty
  home.packages = with pkgs; [
    ghostty
  ];

  # Ghostty configuration using design system colors
  xdg.configFile."ghostty/config".text = ''   
    # Background and foreground (using design system colors)
    background = ${stylesheet.colors.background.primary.conf}
    foreground = ${stylesheet.colors.text.primary.conf}
    
    # Cursor colors
    cursor-color = ${stylesheet.colors.primary."500".conf}
    cursor-text = ${stylesheet.colors.background.primary.conf}
    
    # Selection colors  
    selection-background = ${stylesheet.colors.surface."3".conf}
    selection-foreground = ${stylesheet.colors.text.primary.conf}
    
    # Normal colors (0-7) - using design system semantic colors
    palette = 0=${stylesheet.colors.surface."4".conf}
    palette = 1=${stylesheet.colors.error."500".conf}
    palette = 2=${stylesheet.colors.success."500".conf}
    palette = 3=${stylesheet.colors.warning."500".conf}
    palette = 4=${stylesheet.colors.primary."500".conf}
    palette = 5=${stylesheet.colors.accent."500".conf}
    palette = 6=${stylesheet.colors.secondary."500".conf}
    palette = 7=${stylesheet.colors.text.secondary.conf}
    
    # Bright colors (8-15) - brighter versions
    palette = 8=${stylesheet.colors.text.tertiary.conf}
    palette = 9=${stylesheet.colors.error."400".conf}
    palette = 10=${stylesheet.colors.success."400".conf}
    palette = 11=${stylesheet.colors.warning."400".conf}
    palette = 12=${stylesheet.colors.primary."400".conf}
    palette = 13=${stylesheet.colors.accent."400".conf}
    palette = 14=${stylesheet.colors.secondary."400".conf}
    palette = 15=${stylesheet.colors.text.primary.conf}
    
    # === FONT SETTINGS ===
    font-family = ${stylesheet.typography.fontFamily.mono.single}
    font-size = ${toString stylesheet.typography.fontSize.sm.raw}
    
    # === WINDOW SETTINGS ===
    window-padding-x = ${toString stylesheet.spacing.sm.raw}
    window-padding-y = ${toString stylesheet.spacing.sm.raw}
       
    # Better shell integration
    shell-integration = zsh
    shell-integration-features = cursor,sudo,title
    
    # Mouse behavior
    mouse-hide-while-typing = true
    copy-on-select = true
    
    # Scrollback
    scrollback-limit = 10000
    
    # Terminal identification
    term = xterm-256color
    
    # Cursor settings
    cursor-style = block
    cursor-style-blink = false
    
    # Don't ask for confirmation when closing
    confirm-close-surface = false
    quit-after-last-window-closed = true
    
    # Disable auto-update (managed by Nix)
    auto-update = off
  '';
}
