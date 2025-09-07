{ config, pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;

    # Core editor settings
    settings = {
      theme = "tokyonight";

      editor = {
        line-number = "relative";
        mouse = true;
        cursorline = true;
        color-modes = true;
        bufferline = "always";
        true-color = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        statusline = {
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
          center = [ ];
          right = [ "diagnostics" "selections" "position" "file-encoding" ];
        };

        indent-guides.render = true;
        lsp.display-messages = true;
      };
      keys.normal.space = {
        h = ":toggle lsp.display-inlay-hints";
      };
    };
  };
}
