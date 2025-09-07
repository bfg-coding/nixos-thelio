# modules/development/languages/elixir.nix
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Erlang/OTP and Elixir
    erlang
    elixir

    # Language server for editor support
    elixir-ls
  ];

  # Environment variables for Elixir development
  home.sessionVariables = {
    # Enable shell history in IEx
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  # Useful aliases for Elixir development
  programs.zsh.shellAliases = {
    # Mix shortcuts
    "mx" = "mix";
    "mxt" = "mix test";
    "mxf" = "mix format";

    # IEx shortcuts
    "ixm" = "iex -S mix";
  };

  # Helix configuration for Elixir
  programs.helix.languages = {
    language = [{
      name = "elixir";
      auto-format = true;
      language-servers = [ "elixir-ls" ];
      indent = {
        tab-width = 2;
        unit = "  ";
      };
      formatter = {
        command = "mix";
        args = [ "format" "-" ];
      };
    }];

    language-server = {
      elixir-ls = {
        command = "${pkgs.elixir-ls}/bin/elixir-ls";
        config = {
          elixirLS = {
            dialyzerEnabled = true;
            fetchDeps = true;
            suggestSpecs = true;
            mixEnv = "dev";
          };
        };
      };
    };
  };
}
