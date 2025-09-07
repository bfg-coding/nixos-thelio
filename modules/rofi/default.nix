{ config, pkgs, lib, ... }:

{
  imports = [
    ./themes # Import all themes from the themes directory
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;  # Use rofi-wayland for Hyprland compatibility
    cycle = true;
    location = "center";
    terminal = "${pkgs.ghostty}/bin/ghostty"; # Using ghostty from your configuration
    
    # Adding some useful plugins
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];
    
    # Set active theme - can be changed to any theme in the themes directory
    theme = "cyberpunk";
    
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      icon-theme = "cyberpunk";
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = false;
      
      # Cyberpunk window and interface settings
      window-format = "{w} · {c} · {t}";
      fullscreen = false;
      fake-transparency = false;
      transparency = true;
      
      # Keyboard navigation
      kb-remove-to-eol = "";
      kb-accept-entry = "Return,KP_Enter";
      kb-row-up = "Up,Control+k";
      kb-row-down = "Down,Control+j";
      
      # Animation and appearance
      animation = true;
      animation-length = 300;
      hide-scrollbar = true;
      
      # Application search settings
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      case-sensitive = false;
    };
  };
}
