# modules/swaylock/default.nix
{ config, pkgs, lib, ... }:

{
  # Install supporting packages (swaylock-effects installed system-wide)
  home.packages = with pkgs; [
    swayidle # Idle management
    wlr-randr # Display management
    playerctl # Media control
  ];

  # Create swaylock config file with cyberpunk theme (grace=0 for security)
  xdg.configFile."swaylock/config".text = ''
    # Cyberpunk color scheme matching your theme
    color=091833  # Fallback color when screenshots fail
    bs-hl-color=ea00d9
    caps-lock-bs-hl-color=ea00d9
    caps-lock-key-hl-color=0abdc6
    inside-color=00000000
    inside-clear-color=00000000
    inside-caps-lock-color=00000000
    inside-ver-color=0abdc6
    inside-wrong-color=ea00d9
    key-hl-color=0abdc6
    layout-bg-color=00000000
    layout-border-color=00000000
    layout-text-color=ffffff
    line-color=00000000
    line-clear-color=00000000
    line-caps-lock-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000
    ring-color=133e7c
    ring-clear-color=0abdc6
    ring-caps-lock-color=ea00d9
    ring-ver-color=0abdc6
    ring-wrong-color=ea00d9
    separator-color=00000000
    text-color=ffffff
    text-clear-color=ffffff
    text-caps-lock-color=ffffff
    text-ver-color=ffffff
    text-wrong-color=ffffff

    # Visual effects (optimized for speed)
    effect-blur=7x2
    effect-vignette=0.5:0.5
    fade-in=0.1
    grace=0

    # Font settings
    font=JetBrainsMono Nerd Font
    font-size=24

    # Indicator settings
    indicator
    indicator-radius=120
    indicator-thickness=10
    indicator-caps-lock

    # Layout and positioning
    scaling=fill
    show-failed-attempts
    show-keyboard-layout

    # Clock settings
    clock
    timestr=%I:%M %p
    datestr=%A, %B %d

    # Screenshots enabled for blurred desktop effect
    screenshot=true
  '';

  # Create fast lock script (solid color - instant)
  home.file.".local/bin/lock-screen-fast" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      
      # Pause media (background)
      ${pkgs.playerctl}/bin/playerctl pause 2>/dev/null &
      
      # Fast lock with solid color
      swaylock \
        --color 091833 \
        --effect-vignette 0.5:0.5 \
        --fade-in 0.05 \
        --grace 0 \
        --font "JetBrainsMono Nerd Font" \
        --font-size 24 \
        --indicator \
        --indicator-radius 120 \
        --indicator-thickness 10 \
        --ring-color 133e7c \
        --ring-clear-color 0abdc6 \
        --ring-ver-color 0abdc6 \
        --ring-wrong-color ea00d9 \
        --inside-color 00000000 \
        --inside-ver-color 0abdc6 \
        --inside-wrong-color ea00d9 \
        --text-color ffffff \
        --clock \
        --timestr "%I:%M %p" \
        --datestr "%A, %B %d"
    '';
    executable = true;
  };

  # Create fancy lock script (screenshot + blur - slower but prettier)
  home.file.".local/bin/lock-screen-fancy" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      
      # Pause media (background)
      ${pkgs.playerctl}/bin/playerctl pause 2>/dev/null &
      
      # Fancy lock with screenshot and blur
      swaylock \
        --screenshot \
        --color 091833 \
        --effect-blur 7x2 \
        --effect-vignette 0.5:0.5 \
        --fade-in 0.1 \
        --grace 0 \
        --font "JetBrainsMono Nerd Font" \
        --font-size 24 \
        --indicator \
        --indicator-radius 120 \
        --indicator-thickness 10 \
        --ring-color 133e7c \
        --ring-clear-color 0abdc6 \
        --ring-ver-color 0abdc6 \
        --ring-wrong-color ea00d9 \
        --inside-color 00000000 \
        --inside-ver-color 0abdc6 \
        --inside-wrong-color ea00d9 \
        --text-color ffffff \
        --clock \
        --timestr "%I:%M %p" \
        --datestr "%A, %B %d"
    '';
    executable = true;
  };

  # Replace swayidle with hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "${config.home.homeDirectory}/.local/bin/lock-screen-fast";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 180; # 3 minute to lock screen
          on-timeout = "${config.home.homeDirectory}/.local/bin/lock-screen-fast";
        }
        {
          timeout = 600; # 10 minutes - turn off displays  
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 900; # 15 minutes - suspend system
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
