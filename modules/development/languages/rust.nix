{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core Rust toolchain
    rustc
    cargo
    rustfmt
    clippy

    # Bacon - background Rust code checker
    bacon

    # Additional Rust tools
    cargo-edit # For adding/removing dependencies
    cargo-update # For updating dependencies
    cargo-expand # For expanding macros
  ];


  # Helix Configurations
  programs.helix.languages = {
    language = [
      {
        name = "rust";
        auto-format = true;
        formatter = { command = "${pkgs.rustfmt}/bin/rustfmt"; };
        language-servers = [ "rust-analyzer" ];
      }
    ];
    language-server = {
      rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      };
    };
  };
}
