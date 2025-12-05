{ config, pkgs, lib, ... }:

{
  imports = [
    ./rust.nix
    ./go.nix
    ./csharp.nix
    ./typescript.nix
    ./elixir.nix
    ./c.nix
    ./odin.nix
    ./zig.nix
  ];

  # Install common development tools
  home.packages = with pkgs;
    [
      # Nix tooling
      nixpkgs-fmt
      nil
      nixd
    ];

  # Configure Helix to use these tools
  programs.helix.languages = {
    language = [
      {
        name = "nix";
        auto-format = true;
        formatter = { command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"; };
        language-servers = [ "nil" ];
      }
    ];

    # Define language server configurations
    language-server = {
      nil = {
        command = "${pkgs.nil}/bin/nil";
      };
      nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };
    };
  };
}
