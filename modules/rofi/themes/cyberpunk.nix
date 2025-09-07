{ stylesheet, ... }:



{
  # Place the theme in the correct location for Rofi to find it
  xdg.dataFile."rofi/themes/cyberpunk.rasi".text = ''
    /* Global properties - CrystalNix powered */
    * {
      /* Colors from CrystalNix stylesheet */
      background:     ${stylesheet.colors.background.primary.hex};      /* Tokyo Night main bg */
      background-alt: ${stylesheet.colors.background.secondary.hex};    /* Tokyo Night panel bg */
      background-subtle: ${stylesheet.colors.background.tertiary.hex};  /* Tokyo Night elevated */
      
      foreground:     ${stylesheet.colors.text.primary.hex};            /* Tokyo Night main text */
      foreground-alt: ${stylesheet.colors.text.secondary.hex};          /* Tokyo Night secondary text */
      
      selected:       ${stylesheet.colors.primary."500".hex};           /* Tokyo Night purple */
      accent:         ${stylesheet.colors.info."500".hex};              /* Tokyo Night cyan */
      accent-alt:     ${stylesheet.colors.accent."500".hex};            /* Tokyo Night teal */
      
      urgent:         ${stylesheet.colors.error."500".hex};             /* Tokyo Night coral red */
      warning:        ${stylesheet.colors.warning."500".hex};           /* Tokyo Night orange */
      success:        ${stylesheet.colors.success."500".hex};           /* Tokyo Night green */
      
      /* Typography from CrystalNix */
      font: "${stylesheet.typography.fontFamily.mono.single} ${toString stylesheet.typography.fontSize.xs.raw}";
      
      /* Set transparency - 95% opaque with Tokyo Night background */
      background-color: rgba(26, 27, 38, 0.95);
      text-color: @foreground;
    }

    window {
      transparency: "real";
      border: ${toString stylesheet.borders.width.thick.raw}px;
      border-color: @selected;
      border-radius: ${toString stylesheet.borders.radius.sm.raw}px;
      height: 520px;
      width: 800px;
      location: north;
      anchor: north;
      y-offset: ${toString stylesheet.spacing.md.raw}px;
    }

    mainbox {
      children: [inputbar, message, listview, mode-switcher];
      padding: 0px;
      background-color: @background;
      border: 0;
    }

    /* Input bar */
    inputbar {
      children: [prompt, entry];
      background-color: @background;
      border-radius: ${toString stylesheet.borders.radius.md.raw}px;
      margin: ${toString stylesheet.spacing.md.raw}px ${toString stylesheet.spacing.md.raw}px ${toString stylesheet.spacing.sm.raw}px ${toString stylesheet.spacing.md.raw}px;
      padding: ${toString stylesheet.spacing."1".raw}px;
    }

    prompt {
      background-color: transparent;
      border: ${toString stylesheet.borders.width.normal.raw}px;
      border-color: @selected;
      border-radius: 0px;
      margin: 0px 0px 0px 0px;
      padding: ${toString stylesheet.spacing."2".raw}px ${toString stylesheet.spacing."3".raw}px;
      text-color: @selected;
      text-transform: uppercase;
    }

    entry {
      background-color: @background;
      margin: 0px 0px 0px ${toString stylesheet.spacing.sm.raw}px;
      padding: ${toString (stylesheet.spacing."1".raw + 2)}px;
      text-color: @foreground;
      placeholder: "Search...";
      placeholder-color: rgba(192, 202, 245, 0.5); /* Tokyo Night text with opacity */
    }

    /* Message */
    message {
      background-color: @background-alt;
      margin: 0px ${toString stylesheet.spacing.md.raw}px ${toString stylesheet.spacing.sm.raw}px ${toString stylesheet.spacing.md.raw}px;
      padding: 0px;
      border-radius: ${toString stylesheet.spacing."2".raw}px;
    }

    textbox {
      padding: ${toString stylesheet.spacing.sm.raw}px;
      text-color: @selected;
      background-color: @background;
    }

    /* List view */
    listview {
      background-color: @background;
      border: 0px;
      columns: 1;
      fixed-height: true;
      dynamic: true;
      lines: 10;
      margin: 0px ${toString stylesheet.spacing.md.raw}px ${toString stylesheet.spacing.sm.raw}px ${toString stylesheet.spacing.md.raw}px;
      padding: 0px 0px 0px 0px;
      scrollbar: true;
      spacing: ${toString stylesheet.spacing."1".raw}px;
    }

    scrollbar {
      background-color: @background;
      handle-color: @selected;
      handle-width: ${toString stylesheet.spacing."2".raw}px;
      border-radius: ${toString stylesheet.borders.radius.md.raw}px;
    }

    element {
      background-color: @background;
      padding: ${toString stylesheet.spacing."2".raw}px;
      spacing: ${toString (stylesheet.spacing."1".raw + 1)}px;
    }

    element-icon {
      size: 25px;
      background-color: inherit;
    }

    element-text {
      background-color: inherit;
      text-color: inherit;
      vertical-align: 0.5;
    }

    element selected {
      background-color: @background-subtle;
      border-left: ${toString stylesheet.borders.width.thick.raw}px;
      border-color: @accent;
      padding-left: ${toString stylesheet.spacing."3".raw}px;
      text-color: @accent;
    }

    element normal.urgent, element alternate.urgent {
      background-color: @background;
      text-color: @urgent;
    }

    element normal.active, element alternate.active {
      background-color: @background;
      text-color: @success;
    }

    /* Mode switcher */
    mode-switcher {
      spacing: 0;
      margin: 0px ${toString stylesheet.spacing.md.raw}px ${toString stylesheet.spacing.md.raw}px ${toString stylesheet.spacing.md.raw}px;
      background-color: @background;
    }

    button {
      padding: ${toString stylesheet.spacing.sm.raw}px;
      background-color: @background-alt;
      text-color: @foreground;
    }

    button selected {
      background-color: @background-subtle;
      text-color: @selected;
      border: ${toString stylesheet.borders.width.normal.raw}px;
      border-radius: ${toString stylesheet.borders.radius.md.raw}px;
      border-color: @selected;
    }
  '';
}
