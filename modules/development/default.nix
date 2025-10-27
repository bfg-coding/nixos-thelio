{ config, pkgs, lib, ... }:

{
  imports = [
    ./languages
    ./lsp.nix
    ./docker.nix
    ./ml.nix
  ];

  # Enable direnv for automatic project environment switching
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Add core development libraries and tools - using STABLE OpenSSL
  home.packages = with pkgs; [
    inotify-tools
  ];
}
