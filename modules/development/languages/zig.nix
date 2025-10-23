{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Zig compiler and tools
    zig # Zig compiler (includes build system)
    zls # Zig Language Server

    # Additional useful tools
    lldb # Debugger (Zig uses LLVM)
  ];

  # ZSH aliases for Zig development
  programs.zsh.shellAliases = {
    # Build commands
    "zb" = "zig build";
    "zbr" = "zig build run";
    "zbt" = "zig build test";
    "zbi" = "zig build install";

    # Compilation shortcuts
    "zr" = "zig run";
    "zt" = "zig test";
    "zc" = "zig build-exe";

    # Build modes
    "zb-debug" = "zig build -Doptimize=Debug";
    "zb-release" = "zig build -Doptimize=ReleaseFast";
    "zb-small" = "zig build -Doptimize=ReleaseSmall";
    "zb-safe" = "zig build -Doptimize=ReleaseSafe";

    # Formatting
    "zfmt" = "zig fmt";

    # Documentation
    "zdoc" = "zig build docs";
  };

  # Helix configuration for Zig
  programs.helix.languages = {
    language = [
      {
        name = "zig";
        auto-format = true;
        formatter = {
          command = "${pkgs.zig}/bin/zig";
          args = [ "fmt" "--stdin" ];
        };
        language-servers = [ "zls" ];
        indent = {
          tab-width = 4;
          unit = "    ";
        };
      }
    ];

    language-server = {
      zls = {
        command = "${pkgs.zls}/bin/zls";
        config = {
          enable_snippets = true;
          enable_ast_check_diagnostics = true;
          enable_autofix = true;
          enable_import_embedfile_argument_completions = true;
          warn_style = true;
          enable_semantic_tokens = true;
          enable_inlay_hints = true;
          inlay_hints_show_builtin = true;
          inlay_hints_exclude_single_argument = true;
          inlay_hints_show_parameter_name = true;
          inlay_hints_show_variable_type_hints = true;
          inlay_hints_hide_redundant_param_names = true;
          inlay_hints_hide_redundant_param_names_last_token = true;
        };
      };
    };
  };
}
