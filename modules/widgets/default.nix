# modules/widgets/default.nix
{ config, pkgs, lib, stylesheet, ... }:

{
  # Install AGS and basic dependencies
  home.packages = with pkgs; [
    ags # Aylur's GTK Shell
    dart-sass # SCSS compilation (for theme.scss)
  ];

  # Generate theme.scss for AGS project to import
  home.file.".config/ags/styles/theme.scss" = {
    text = ''
      // 🚫 DO NOT EDIT - Generated from CrystalNix theme system
      // To modify theme values, edit your CrystalNix configuration
      
      // Colors
      $primary: ${stylesheet.colors.primary."500".hex};
      $secondary: ${stylesheet.colors.secondary."500".hex};
      $accent: ${stylesheet.colors.accent."500".hex};
      $success: ${stylesheet.colors.success."500".hex};
      $warning: ${stylesheet.colors.warning."500".hex};
      $error: ${stylesheet.colors.error."500".hex};
      $info: ${stylesheet.colors.info."500".hex};
      
      $background: ${stylesheet.colors.background.primary.hex};
      $background-secondary: ${stylesheet.colors.background.secondary.hex};
      $background-tertiary: ${stylesheet.colors.background.tertiary.hex};
      
      $text: ${stylesheet.colors.text.primary.hex};
      $text-secondary: ${stylesheet.colors.text.secondary.hex};
      $text-tertiary: ${stylesheet.colors.text.tertiary.hex};
      
      $surface-1: ${stylesheet.colors.surface."1".hex};
      $surface-2: ${stylesheet.colors.surface."2".hex};
      $surface-3: ${stylesheet.colors.surface."3".hex};
      $surface-4: ${stylesheet.colors.surface."4".hex};
      
      // Spacing
      $spacing-xs: ${toString stylesheet.spacing.xs.raw}px;
      $spacing-sm: ${toString stylesheet.spacing.sm.raw}px;
      $spacing-md: ${toString stylesheet.spacing.md.raw}px;
      $spacing-lg: ${toString stylesheet.spacing.lg.raw}px;
      $spacing-xl: ${toString stylesheet.spacing.xl.raw}px;
      
      // Typography
      $font-mono: "${stylesheet.typography.fontFamily.mono.single}";
      $font-sans: "${stylesheet.typography.fontFamily.sans.single}";
      $font-size-xs: ${toString stylesheet.typography.fontSize.xs.raw}px;
      $font-size-sm: ${toString stylesheet.typography.fontSize.sm.raw}px;
      $font-size-base: ${toString stylesheet.typography.fontSize.base.raw}px;
      $font-size-lg: ${toString stylesheet.typography.fontSize.lg.raw}px;
      $font-size-xl: ${toString stylesheet.typography.fontSize.xl.raw}px;
      
      // Borders
      $border-radius-sm: ${toString stylesheet.borders.radius.sm.raw}px;
      $border-radius-md: ${toString stylesheet.borders.radius.md.raw}px;
      $border-radius-lg: ${toString stylesheet.borders.radius.lg.raw}px;
      
      // Border widths
      $border-width-normal: ${toString stylesheet.borders.width.normal.raw}px;
      $border-width-thick: ${toString stylesheet.borders.width.thick.raw}px;
    '';
    onChange = ''
      # Recompile SCSS when theme changes
      if [ -f ~/.config/ags/styles/widgets.scss ]; then
        ${pkgs.dart-sass}/bin/sass ~/.config/ags/styles/widgets.scss ~/.config/ags/style.css
      fi
    '';
  };

  # Export theme as JSON for TypeScript import (alternative to SCSS)
  home.file.".config/ags/theme.json".text = builtins.toJSON {
    colors = {
      primary = stylesheet.colors.primary."500".hex;
      secondary = stylesheet.colors.secondary."500".hex;
      accent = stylesheet.colors.accent."500".hex;
      success = stylesheet.colors.success."500".hex;
      warning = stylesheet.colors.warning."500".hex;
      error = stylesheet.colors.error."500".hex;
      info = stylesheet.colors.info."500".hex;

      background = {
        primary = stylesheet.colors.background.primary.hex;
        secondary = stylesheet.colors.background.secondary.hex;
        tertiary = stylesheet.colors.background.tertiary.hex;
      };

      text = {
        primary = stylesheet.colors.text.primary.hex;
        secondary = stylesheet.colors.text.secondary.hex;
        tertiary = stylesheet.colors.text.tertiary.hex;
      };

      surface = {
        "1" = stylesheet.colors.surface."1".hex;
        "2" = stylesheet.colors.surface."2".hex;
        "3" = stylesheet.colors.surface."3".hex;
        "4" = stylesheet.colors.surface."4".hex;
      };
    };

    spacing = {
      xs = stylesheet.spacing.xs.raw;
      sm = stylesheet.spacing.sm.raw;
      md = stylesheet.spacing.md.raw;
      lg = stylesheet.spacing.lg.raw;
      xl = stylesheet.spacing.xl.raw;
    };

    typography = {
      fontFamily = {
        mono = stylesheet.typography.fontFamily.mono.single;
        sans = stylesheet.typography.fontFamily.sans.single;
      };
      fontSize = {
        xs = stylesheet.typography.fontSize.xs.raw;
        sm = stylesheet.typography.fontSize.sm.raw;
        base = stylesheet.typography.fontSize.base.raw;
        lg = stylesheet.typography.fontSize.lg.raw;
        xl = stylesheet.typography.fontSize.xl.raw;
      };
    };

    borders = {
      radius = {
        sm = stylesheet.borders.radius.sm.raw;
        md = stylesheet.borders.radius.md.raw;
        lg = stylesheet.borders.radius.lg.raw;
      };
      width = {
        normal = stylesheet.borders.width.normal.raw;
        thick = stylesheet.borders.width.thick.raw;
      };
    };
  };

  # Setup systemd service for AGS
  systemd.user.services.ags = {
    Unit = {
      Description = "Aylur's GTK Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ags}/bin/ags run ~/.config/ags/app.tsx";
      Restart = "on-failure";
      RestartSec = "3";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };


}
