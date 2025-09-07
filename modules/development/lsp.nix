{ config, pkgs, lib, ... }:
{
  programs.helix.settings = {
    editor.lsp = {
      display-messages = true;
      display-inlay-hints = true;
    };
  };

  # LSP integration settings
  programs.helix.languages.language-server = {
    gopls = {
      config = {
        # Enhance editor experience
        semanticTokens = true;
        # Enable inlay hints (type hints, paramters names)
        hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
      # Improve memory usage limit for large projects
      memoryMode = "DegradeClosed";
    };
  };

  # Extra packages specifically for Go development
  home.packages = with pkgs; [
    # Go test runner with colorized output
    gotestsum
    # Go code coverage tool
    go-tools # contains cover, callgraph, etc.
    # Go dependency management
    govulncheck
  ];
}
