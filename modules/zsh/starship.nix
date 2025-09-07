# modules/starship.nix - CrystalNix powered Starship configuration
{ config, pkgs, stylesheet, lib, ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # FIRST LINE/ROW: Info & Status

      # First param ─┌
      username = {
        format = " [╭─$user]($style)@";
        style_user = "bold ${stylesheet.colors.info."500".hex}"; # Tokyo Night cyan
        style_root = "bold ${stylesheet.colors.info."500".hex}";
        show_always = true;
      };

      # Second param
      hostname = {
        format = "[$hostname]($style) in ";
        style = "bold dimmed ${stylesheet.colors.secondary."500".hex}"; # Tokyo Night blue
        trim_at = "-";
        ssh_only = false;
        disabled = false;
      };

      # Third param
      directory = {
        style = "${stylesheet.colors.primary."500".hex}"; # Tokyo Night purple
        truncation_length = 0;
        truncate_to_repo = true;
        truncation_symbol = "repo: ";
      };

      # Before all the version info
      git_status = {
        style = "${stylesheet.colors.error."500".hex}"; # Tokyo Night coral red
        ahead = "⇡$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        behind = "⇣$count";
        deleted = "x";
      };

      # Last param in the first line/row
      cmd_duration = {
        min_time = 1;
        format = "took [$duration]($style)";
        disabled = false;
      };

      # SECOND LINE/ROW: Prompt

      # Battery indicators (disabled but configured)
      battery = {
        full_symbol = " ";
        charging_symbol = " ";
        discharging_symbol = " ";
        disabled = true;

        display = [
          {
            threshold = 15;
            style = "bold ${stylesheet.colors.error."500".hex}";
            disabled = true;
          }
          {
            threshold = 50;
            style = "bold ${stylesheet.colors.warning."500".hex}";
            disabled = true;
          }
          {
            threshold = 80;
            style = "bold ${stylesheet.colors.success."500".hex}";
            disabled = true;
          }
        ];
      };

      # Time (disabled but configured)
      time = {
        format = " 🕙 $time($style)\n";
        time_format = "%T";
        style = "${stylesheet.colors.text.primary.hex}";
        disabled = true;
      };

      # Prompt character
      character = {
        success_symbol = " [╰─λ](bold ${stylesheet.colors.info."500".hex})"; # Tokyo Night cyan
        error_symbol = " [×](bold ${stylesheet.colors.primary."500".hex})"; # Tokyo Night purple for errors
      };

      # Status indicator
      status = {
        symbol = "🔴";
        format = "[\\[$symbol$status_common_meaning$status_signal_name$status_maybe_int\\]]($style)";
        map_symbol = true;
        disabled = false;
      };

      # SYMBOLS FOR PROGRAMMING LANGUAGES AND TOOLS
      aws.symbol = " ";
      conda.symbol = " ";
      dart.symbol = " ";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";

      git_branch = {
        symbol = " ";
        style = "${stylesheet.colors.accent."500".hex}"; # Tokyo Night teal
      };

      golang.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      nim.symbol = " ";

      nix_shell = {
        symbol = " ";
        style = "${stylesheet.colors.info."500".hex}"; # Tokyo Night cyan for nix shells
      };

      nodejs.symbol = " ";
      package.symbol = " ";
      perl.symbol = " ";
      php.symbol = " ";
      python.symbol = " ";
      ruby.symbol = " ";
      rust.symbol = " ";
      swift.symbol = "ﯣ ";

      # Additional language styling using design system colors
      c = {
        style = "${stylesheet.colors.secondary."500".hex}";
      };

      cpp = {
        style = "${stylesheet.colors.secondary."500".hex}";
      };

      kubernetes = {
        style = "${stylesheet.colors.primary."500".hex}";
      };

      terraform = {
        style = "${stylesheet.colors.accent."500".hex}";
      };

      # Custom styling for different contexts
      shell = {
        style = "${stylesheet.colors.text.secondary.hex}";
        disabled = false;
      };

      memory_usage = {
        style = "${stylesheet.colors.warning."500".hex}";
        threshold = 75;
        disabled = false;
      };

      # Format styling
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
    };
  };
}
