{ config, pkgs, lib, stylesheet, ... }:

let
  # Extract all color values once at the top for use throughout the config
  colors = {
    # Background colors
    bgPrimary = stylesheet.colors.background.primary.hex;
    bgSecondary = stylesheet.colors.background.secondary.hex;

    # Text colors
    textPrimary = stylesheet.colors.text.primary.hex;
    textSecondary = stylesheet.colors.text.secondary.hex;
    textTertiary = stylesheet.colors.text.tertiary.hex;

    # Theme colors
    primary500 = stylesheet.colors.primary."500".hex;
    primary400 = stylesheet.colors.primary."400".hex;
    accent500 = stylesheet.colors.accent."500".hex;
    secondary500 = stylesheet.colors.secondary."500".hex;

    # Surface colors
    surface1 = stylesheet.colors.surface."1".hex;
    surface2 = stylesheet.colors.surface."2".hex;
    surface3 = stylesheet.colors.surface."3".hex;

    # Semantic colors
    errorColor = stylesheet.colors.error."500".hex;
    warningColor = stylesheet.colors.warning."500".hex;
    successColor = stylesheet.colors.success."500".hex;
    infoColor = stylesheet.colors.info."500".hex;

    # Border colors
    borderPrimary = stylesheet.colors.border.primary.hex;
    borderSecondary = stylesheet.colors.border.secondary.hex;
  };

  # Typography values
  typography = {
    fontFamily = "JetBrainsMono Nerd Font Propo";
    fontSize = toString stylesheet.typography.fontSize.xs.raw;
    fontWeightMedium = toString stylesheet.typography.fontWeight.medium.raw;
    fontWeightBold = toString stylesheet.typography.fontWeight.bold.raw;
  };

  # Spacing and sizing values (as integers for waybar settings)
  spacing = {
    xs = stylesheet.spacing.xs.raw;
    sm = stylesheet.spacing.sm.raw;
    md = stylesheet.spacing.md.raw;
    space1 = stylesheet.spacing."1".raw;
    # String versions for CSS
    xsStr = toString stylesheet.spacing.xs.raw;
    smStr = toString stylesheet.spacing.sm.raw;
    mdStr = toString stylesheet.spacing.md.raw;
    space1Str = toString stylesheet.spacing."1".raw;
  };

  # Border values
  borders = {
    radiusSm = toString stylesheet.borders.radius.sm.raw;
    radiusMd = toString stylesheet.borders.radius.md.raw;
    widthThin = toString stylesheet.borders.width.thin.raw;
  };

  # Motion values
  motion = {
    durationFast = toString stylesheet.motion.duration.fast.raw;
  };
in
{
  # Enable and configure Waybar
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };

    settings = {
      # Primary Monitor Bar (Main workspaces 1-5)
      mainBar = {
        layer = "top";
        position = "top";
        # Auto-detect primary monitor - update these if you know your monitor names
        output = [ "eDP-1" ]; # Uncomment and set to your primary monitor
        height = 32;
        spacing = 4;
        margin-top = spacing.xs;
        margin-left = spacing.sm;
        margin-right = spacing.sm;

        # Module layout for primary monitor
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          "battery"
          "network"
          "pulseaudio"
          "cpu"
          "memory"
          "tray"
          "custom/power"
        ];

        # Primary monitor workspaces (1-5)
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false; # Only show this monitor's workspaces
          warp-on-scroll = false;
          format = "{icon}";
          format-icons = {
            "1" = "󰲠"; # Terminal/Code
            "2" = "󰈹"; # Web/Browser  
            "3" = "󰉋"; # Files
            "4" = "󰙯"; # Communication
            "5" = "󰝚"; # Media/Music
            "urgent" = "";
            "focused" = "";
            "default" = "󰋙";
          };

          # Only show workspaces 1-5 on primary monitor
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };

          # Smooth scrolling between workspaces
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        # Window title with better truncation for primary monitor
        "hyprland/window" = {
          max-length = 60; # Longer for main monitor
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "🌐 $1";
            "(.*) - Visual Studio Code" = "💻 $1";
            "(.*) - Helix" = "📝 $1";
            "(.*)Spotify" = "🎵 $1";
            "(.*)Discord" = "💬 Discord";
          };
        };

        # Enhanced clock with calendar
        "clock" = {
          interval = 1;
          format = "{:%I:%M %p}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";

          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='${colors.primary500}'><b>{}</b></span>";
              days = "<span color='${colors.textPrimary}'>{}</span>";
              weeks = "<span color='${colors.accent500}'><b>W{}</b></span>";
              weekdays = "<span color='${colors.secondary500}'><b>{}</b></span>";
              today = "<span color='${colors.warningColor}'><b><u>{}</u></b></span>";
            };
          };

          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        # Network with better status indicators
        "network" = {
          interval = 2;
          format-wifi = "   {essid} ({signalStrength}%)";
          format-ethernet = "󰈁  Wired";
          format-linked = "󰈁  {ifname} (No IP)";
          format-disconnected = "󰈂  Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}\n{ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}";
          tooltip-format-ethernet = "{ifname}\n{ipaddr}/{cidr}";

          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          on-click-right = "${pkgs.networkmanager}/bin/nmcli device wifi rescan";
        };


        # Add this to your mainBar settings, after the memory module
        "battery" = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-full = "󱈑 {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];

          tooltip = true;
          tooltip-format = "Battery: {capacity}%\nTime: {time}\nPower: {power}W";
        };

        # Enhanced audio control (primary monitor gets full control)
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}%";
          format-bluetooth-muted = "󰸈 {icon}";
          format-muted = "󰸈  Muted";
          format-source = "  {volume}%";
          format-source-muted = "  Muted";

          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };

          scroll-step = 5;
          on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
          on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
        };

        # System monitoring
        "cpu" = {
          interval = 10;
          format = "  {usage}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "CPU Usage: {usage}%\nLoad: {load}";

          on-click = "${pkgs.btop}/bin/btop";
        };

        "memory" = {
          interval = 30;
          format = "  {}%";
          max-length = 10;
          tooltip = true;
          tooltip-format = "Memory: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";

          on-click = "${pkgs.btop}/bin/btop";
        };

        # System tray
        "tray" = {
          icon-size = 18;
          spacing = 8;
        };

        # Power menu button
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "${pkgs.rofi-wayland}/bin/rofi -show power-menu -modi power-menu:~/.local/bin/rofi-power-menu";
          escape = true;
        };
      };

      # Secondary Monitor Bar (Workspaces 6-10)
      secondaryBar = {
        layer = "top";
        position = "top";
        # Auto-detect secondary monitor - update if you know your monitor names
        output = [ "DP-3" ]; # Uncomment and set to your secondary monitor
        height = 32;
        spacing = 4;
        margin-top = spacing.xs;
        margin-left = spacing.sm;
        margin-right = spacing.sm;

        # Module layout for secondary monitor
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "custom/monitor-info" ];

        # Secondary monitor workspaces (6-10)
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          warp-on-scroll = false;
          format = "{icon}";
          format-icons = {
            "6" = "󰊴"; # Documents
            "7" = "󰊗"; # Games/Fun
            "8" = "󰐾"; # Settings
            "9" = "󰍉"; # Downloads
            "10" = "󰜎"; # Misc
            "urgent" = "";
            "focused" = "";
            "default" = "󰋙";
          };

          # Only show workspaces 6-10 on secondary monitor
          persistent-workspaces = {
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "10" = [ ];
          };

          # Smooth scrolling between workspaces
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        # Window title for secondary monitor
        "hyprland/window" = {
          max-length = 45; # Shorter for secondary monitor
          separate-outputs = true;
          rewrite = {
            "(.*) — Mozilla Firefox" = "🌐 $1";
            "(.*) - Visual Studio Code" = "💻 $1";
            "(.*) - Helix" = "📝 $1";
            "(.*)Spotify" = "🎵 $1";
            "(.*)Discord" = "💬 Discord";
          };
        };

        # Simpler clock for secondary monitor
        "clock" = {
          format = "{:%H:%M}"; # 24-hour format for secondary
          format-alt = "{:%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };

        # Monitor indicator for secondary
        "custom/monitor-info" = {
          format = "󰍹 Secondary";
          tooltip = "Secondary Monitor";
        };
      };
    };

    # Enhanced CSS using extracted design system values
    style = ''
      /* Global styling using design system */
      * {
        font-family: "${typography.fontFamily}";
        font-size: ${typography.fontSize}pt;
        border: none;
        border-radius: 0;
        font-weight: ${typography.fontWeightMedium};
      }
      
      /* Main waybar window */
      window#waybar {
        background-color: ${colors.bgPrimary};
        opacity: 0.95;
        color: ${colors.textPrimary};
        transition-property: background-color;
        transition-duration: ${motion.durationFast}ms;
        border-radius: ${borders.radiusMd}px;
        border: ${borders.widthThin}px solid ${colors.borderPrimary};
        box-shadow: 0 ${spacing.xsStr}px ${spacing.smStr}px rgba(0, 0, 0, 0.2);
      }
      
      /* Workspaces container */
      #workspaces {
        background-color: ${colors.surface1};
        border-radius: ${borders.radiusMd}px;
        margin-right: ${spacing.smStr}px;
        margin-left: ${spacing.xsStr}px;
        padding: ${spacing.xsStr}px ${spacing.smStr}px;
        border: ${borders.widthThin}px solid ${colors.borderSecondary};
      }
      
      /* Individual workspace buttons */
      #workspaces button {
        padding: ${spacing.xsStr}px ${spacing.smStr}px;
        margin: 0 ${spacing.space1Str}px;
        background-color: transparent;
        color: ${colors.textTertiary};
        border-radius: ${borders.radiusSm}px;
        transition: background-color ${motion.durationFast}ms ease-out, color ${motion.durationFast}ms ease-out;
        min-width: 24px;
      }
      
      /* Hover effect for workspaces */
      #workspaces button:hover {
        background-color: ${colors.surface2};
        color: ${colors.textSecondary};
      }
      
      /* ACTIVE WORKSPACE - Background color instead of border */
      #workspaces button.active {
        background-color: ${colors.primary500};
        color: ${colors.bgPrimary};
        font-weight: ${typography.fontWeightBold};
        box-shadow: 0 ${spacing.space1Str}px ${spacing.xsStr}px rgba(0, 0, 0, 0.3);
      }
      
      /* Urgent workspace */
      #workspaces button.urgent {
        background-color: ${colors.errorColor};
        color: ${colors.bgPrimary};
        animation: urgent-pulse 2s ease-in-out infinite;
      }
      
      @keyframes urgent-pulse {
        0% { opacity: 1; }
        50% { opacity: 0.7; }
        100% { opacity: 1; }
      }
      
      /* Window title */
      #window {
        color: ${colors.textSecondary};
        font-style: italic;
        margin-left: ${spacing.smStr}px;
        padding: 0 ${spacing.smStr}px;
      }
      
      /* Clock styling */
      #clock {
        color: ${colors.primary400};
        font-weight: ${typography.fontWeightMedium};
        padding: 0 ${spacing.mdStr}px;
        background-color: ${colors.surface1};
        border-radius: ${borders.radiusMd}px;
        border: ${borders.widthThin}px solid ${colors.primary500};
        opacity: 0.9;
      }
      
      /* Right modules container */
      #network,
      #cpu,
      #memory,
      #pulseaudio,
      #tray,
      #custom-monitor-info,
      #custom-power {
        padding: ${spacing.xsStr}px ${spacing.smStr}px;
        margin: 0 ${spacing.xsStr}px;
        background-color: ${colors.surface1};
        border-radius: ${borders.radiusSm}px;
        border: ${borders.widthThin}px solid ${colors.borderSecondary};
        transition: background-color ${motion.durationFast}ms ease-out, border-color ${motion.durationFast}ms ease-out, opacity ${motion.durationFast}ms ease-out;
        color: ${colors.textPrimary};
        opacity: 0.9;
      }
      
      /* Hover effects for modules */
      #network:hover,
      #cpu:hover,
      #memory:hover,
      #pulseaudio:hover {
        background-color: ${colors.surface2};
        border-color: ${colors.primary500};
        opacity: 1;
      }
      
      /* Network status indicators */
      #network.disconnected {
        color: ${colors.errorColor};
        border-color: ${colors.errorColor};
      }
      
      #network.wifi {
        color: ${colors.infoColor};
        border-color: ${colors.infoColor};
      }
      
      #network.ethernet {
        color: ${colors.successColor};
        border-color: ${colors.successColor};
      }

      /* Battery styling */
      #battery {
        color: ${colors.successColor};
        border-color: ${colors.successColor};
      }

      #battery.charging {
        color: ${colors.infoColor};
        border-color: ${colors.infoColor};
        animation: charging-pulse 2s ease-in-out infinite;
      }

      #battery.warning:not(.charging) {
        color: ${colors.warningColor};
        border-color: ${colors.warningColor};
      }

      #battery.critical:not(.charging) {
        color: ${colors.errorColor};
        border-color: ${colors.errorColor};
        animation: critical-pulse 1s ease-in-out infinite;
      }

      @keyframes charging-pulse {
        0% { opacity: 0.9; }
        50% { opacity: 1; }
        100% { opacity: 0.9; }
      }

      @keyframes critical-pulse {
        0% { opacity: 1; }
        50% { opacity: 0.6; }
        100% { opacity: 1; }
      }
      
      /* Audio muted state */
      #pulseaudio.muted {
        color: ${colors.errorColor};
        border-color: ${colors.errorColor};
      }
      
      /* System tray */
      #tray {
        background-color: ${colors.surface1};
        border-color: ${colors.borderSecondary};
      }
      
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: ${colors.warningColor};
      }
      
      /* Secondary monitor specific styling */
      #custom-monitor-info {
        color: ${colors.textTertiary};
        font-size: 11pt;
        opacity: 0.8;
      }
      
      /* Power button styling */
      #custom-power {
        color: ${colors.errorColor};
        border-color: ${colors.errorColor};
        font-weight: ${typography.fontWeightBold};
      }
      
      #custom-power:hover {
        background-color: ${colors.errorColor};
        color: ${colors.bgPrimary};
      }
      
      /* Tooltip styling */
      tooltip {
        background-color: ${colors.surface3};
        color: ${colors.textPrimary};
        border-radius: ${borders.radiusMd}px;
        border: ${borders.widthThin}px solid ${colors.borderPrimary};
        padding: ${spacing.smStr}px;
      }
    '';
  };
}
