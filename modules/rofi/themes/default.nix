# modules/rofi/themes/default.nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./cyberpunk.nix
    # Add other themes here as you create them
    # ./nord.nix
    # ./tokyo-night.nix
    # etc.
  ];
}
