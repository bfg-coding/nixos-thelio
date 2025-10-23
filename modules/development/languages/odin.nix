{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Odin compiler
    odin

    # Odin Language Server
    ols # Odin Language Server

    # Debugger (Odin uses LLVM)
    lldb
  ];

  # ZSH aliases for Odin development
  programs.zsh.shellAliases = {
    # Build commands
    "ob" = "odin build .";
    "obr" = "odin run .";
    "obt" = "odin test .";
    "obc" = "odin check .";

    # Build modes
    "ob-debug" = "odin build . -debug";
    "ob-release" = "odin build . -o:speed";
    "ob-size" = "odin build . -o:size";

    # Documentation and reporting
    "odoc" = "odin doc";
    "orep" = "odin report";

    # Version info
    "oversion" = "odin version";
  };

  # Helix configuration for Odin
  programs.helix.languages = {
    language = [
      {
        name = "odin";
        auto-format = true;
        language-servers = [ "ols" ];
        indent = {
          tab-width = 4;
          unit = "\t"; # Odin convention uses tabs
        };
        comment-token = "//";
        file-types = [ "odin" ];
      }
    ];

    language-server = {
      ols = {
        command = "${pkgs.ols}/bin/ols";
        config = {
          enable_snippets = true;
          enable_semantic_tokens = true;
          enable_inlay_hints = true;
          enable_procedure_snippet = true;
        };
      };
    };
  };
}
