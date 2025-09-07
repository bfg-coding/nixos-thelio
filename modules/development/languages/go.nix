{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Golang
    go
    gopls # Go language server
    delve # Go debugger
    golangci-lint # Linter
    gotools # Contains goimports and other golang tooling
  ];

  # Configure custom env values
  xdg.configFile."go/env" = {
    text = ''
      GOPATH=${config.home.homeDirectory}/.go
      GOBIN=${config.home.homeDirectory}/.go/bin
    '';
  };

  # Create ZSH profile to ensure GOPATH/bin is in PATH
  programs.zsh = {
    enable = true;
    # Use profileExtra instead of envExtra/initExtra for PATH
    profileExtra = ''
      # Add Go bin to PATH - must be in profileExtra for correct order
      export PATH="$HOME/.go/bin:$PATH"
    '';
  };

  # For global environment (needed for other shells/applications)
  home.sessionVariables = {
    # These might get overridden in ZSH but will work in other contexts
    GOPATH = "${config.home.homeDirectory}/.go";
    GOBIN = "${config.home.homeDirectory}/.go/bin";
  };

  # Helix Configurations
  programs.helix.languages = {
    language = [
      {
        name = "go";
        auto-format = true;
        formatter = { command = "${pkgs.gotools}/bin/goimports"; };
        language-servers = [ "gopls" ];
      }
    ];
    language-server = {
      gopls = {
        command = "${pkgs.gopls}/bin/gopls";
        args = [ "serve" "-rpc.trace" ];
        config = {
          usePlaceholders = true;
          analyses = {
            unusedparams = true;
            shadow = true;
            nilness = true;
            unusedwrite = true;
            useany = true;
          };
          # Enable staticcheck for additional linting
          staticcheck = true;
          # Make completion more fuzzy
          matcher = "fuzzy";
          # Support completion for packages not yet imported
          completeUnimported = true;
          # Add documentation to completion items
          completionDocumentation = true;
          # Organize imports when formatting
          gofumpt = true;
        };
      };
    };
  };
}
