{ config, pkgs, stylesheet, ... }:

{
  gtk = {
    enable = true;

    # GTK 3 theme (gnome-themes-extra supports GTK 2/3)
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    # GTK 3 settings
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-theme-name = "Adwaita-dark";
      gtk-icon-theme-name = "Adwaita";
      gtk-font-name = "JetBrainsMono Nerd Font 11";
      gtk-cursor-theme-name = "Adwaita";
      gtk-cursor-theme-size = 24;
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-enable-event-sounds = 1;
      gtk-enable-input-feedback-sounds = 1;
      gtk-dialogs-use-header = 1;
      gtk-primary-button-warps-slider = 1;
    };

    # GTK 4 settings (no gnome-themes-extra here)
    gtk4.extraConfig = {
      gtk-theme-name = "Adwaita"; # Let libadwaita handle dark mode
      gtk-icon-theme-name = "Adwaita";
      gtk-font-name = "JetBrainsMono Nerd Font 11";
      gtk-cursor-theme-name = "Adwaita";
      gtk-cursor-theme-size = 24;
    };

    # GTK 3 custom CSS
    gtk3.extraCss = ''
      * {
        background-color: ${stylesheet.colors.background.primary.hex};
        color: ${stylesheet.colors.text.primary.hex};
      }
      button {
        background-color: ${stylesheet.colors.background.primary.hex};
        color: ${stylesheet.colors.text.primary.hex};
        border: 1px solid ${stylesheet.colors.border.primary.hex};
        border-radius: ${stylesheet.spacing.xs.px};
        padding: ${stylesheet.spacing.sm.px} ${stylesheet.spacing.md.px};
        font-family: ${stylesheet.typography.fontFamily.sans.css};
      }
      button:hover {
        background-color: ${stylesheet.colors.background.secondary.hex};
      }
      entry {
        background-color: ${stylesheet.colors.background.secondary.hex};
        color: ${stylesheet.colors.text.primary.hex};
        border: 1px solid ${stylesheet.colors.border.primary.hex};
        border-radius: ${stylesheet.spacing.xs.px};
        padding: ${stylesheet.spacing.sm.px};
      }
      entry:focus {
        border-color: ${stylesheet.colors.primary."500".hex};
      }
      headerbar {
        background-color: ${stylesheet.colors.background.primary.hex};
        color: ${stylesheet.colors.text.primary.hex};
      }
    '';
  };

  # GTK 4 custom CSS (installed into ~/.config/gtk-4.0/gtk.css)
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    * {
      background-color: ${stylesheet.colors.background.primary.hex};
      color: ${stylesheet.colors.text.primary.hex};
    }
    button {
      background-color: ${stylesheet.colors.background.primary.hex};
      color: ${stylesheet.colors.text.primary.hex};
      border: 1px solid ${stylesheet.colors.border.primary.hex};
      border-radius: ${stylesheet.spacing.xs.px};
      padding: ${stylesheet.spacing.sm.px} ${stylesheet.spacing.md.px};
      font-family: ${stylesheet.typography.fontFamily.sans.css};
    }
    button:hover {
      background-color: ${stylesheet.colors.background.secondary.hex};
    }
    entry {
      background-color: ${stylesheet.colors.background.secondary.hex};
      color: ${stylesheet.colors.text.primary.hex};
      border: 1px solid ${stylesheet.colors.border.primary.hex};
      border-radius: ${stylesheet.spacing.xs.px};
      padding: ${stylesheet.spacing.sm.px};
    }
    entry:focus-within {
      border-color: ${stylesheet.colors.primary."500".hex};
    }
    headerbar {
      background-color: ${stylesheet.colors.background.primary.hex};
      color: ${stylesheet.colors.text.primary.hex};
    }
  '';
}
