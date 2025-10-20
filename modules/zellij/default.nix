{ stylesheet, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;

    # Set the theme to use CrystalNix values
    settings = {
      theme = "crystalnix";
    };
  };


  # Creating useful aliases for Zellij
  programs.zsh.shellAliases = {
    "zj" = "zellij";
    "zja" = "zellij attach";
    "zjs" = "zellij -s";
    "zjsm" = "zellij session-manager";
  };

  # Create the theme file manually with proper UI component structure
  xdg.configFile."zellij/themes/crystalnix.kdl".text = ''
    themes {
      crystalnix {
        text_unselected {
          base ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        text_selected {
          base ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          background ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_0 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        ribbon_unselected {
          base ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
          background ${toString stylesheet.colors.background.secondary.rgb.r} ${toString stylesheet.colors.background.secondary.rgb.g} ${toString stylesheet.colors.background.secondary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
        }

        ribbon_selected {
          base ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          background ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_0 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        list_unselected {
          base ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        list_selected {
          base ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          background ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        table_cell_unselected {
          base ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        table_cell_selected {
          base ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          background ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_0 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        table_title {
          base ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        frame_selected {
          base ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        frame_highlight {
          base ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_2 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        exit_code_success {
          base ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        exit_code_error {
          base ${toString stylesheet.colors.error."500".rgb.r} ${toString stylesheet.colors.error."500".rgb.g} ${toString stylesheet.colors.error."500".rgb.b}
          background ${toString stylesheet.colors.background.primary.rgb.r} ${toString stylesheet.colors.background.primary.rgb.g} ${toString stylesheet.colors.background.primary.rgb.b}
          emphasis_0 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          emphasis_1 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          emphasis_2 ${toString stylesheet.colors.text.primary.rgb.r} ${toString stylesheet.colors.text.primary.rgb.g} ${toString stylesheet.colors.text.primary.rgb.b}
          emphasis_3 ${toString stylesheet.colors.text.secondary.rgb.r} ${toString stylesheet.colors.text.secondary.rgb.g} ${toString stylesheet.colors.text.secondary.rgb.b}
        }

        multiplayer_user_colors {
          player_1 ${toString stylesheet.colors.primary."500".rgb.r} ${toString stylesheet.colors.primary."500".rgb.g} ${toString stylesheet.colors.primary."500".rgb.b}
          player_2 ${toString stylesheet.colors.accent."500".rgb.r} ${toString stylesheet.colors.accent."500".rgb.g} ${toString stylesheet.colors.accent."500".rgb.b}
          player_3 ${toString stylesheet.colors.success."500".rgb.r} ${toString stylesheet.colors.success."500".rgb.g} ${toString stylesheet.colors.success."500".rgb.b}
          player_4 ${toString stylesheet.colors.warning."500".rgb.r} ${toString stylesheet.colors.warning."500".rgb.g} ${toString stylesheet.colors.warning."500".rgb.b}
          player_5 ${toString stylesheet.colors.error."500".rgb.r} ${toString stylesheet.colors.error."500".rgb.g} ${toString stylesheet.colors.error."500".rgb.b}
          player_6 ${toString stylesheet.colors.info."500".rgb.r} ${toString stylesheet.colors.info."500".rgb.g} ${toString stylesheet.colors.info."500".rgb.b}
          player_7 ${toString stylesheet.colors.secondary."500".rgb.r} ${toString stylesheet.colors.secondary."500".rgb.g} ${toString stylesheet.colors.secondary."500".rgb.b}
          player_8 ${toString stylesheet.colors.primary."700".rgb.r} ${toString stylesheet.colors.primary."700".rgb.g} ${toString stylesheet.colors.primary."700".rgb.b}
          player_9 ${toString stylesheet.colors.accent."700".rgb.r} ${toString stylesheet.colors.accent."700".rgb.g} ${toString stylesheet.colors.accent."700".rgb.b}
          player_10 ${toString stylesheet.colors.success."700".rgb.r} ${toString stylesheet.colors.success."700".rgb.g} ${toString stylesheet.colors.success."700".rgb.b}
        }
      }
    }
  '';
}
