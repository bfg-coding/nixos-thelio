{ config, pkgs, lib, ... }:
{
  imports = [
    ./helix
    ./jetbrains
    # Other editor modules if you add them later
  ];

  editors.jetbrains = {
    enable = true;
    toolbox.enable = true;
    directIDEs = [ ];
    hyprlandIntegration = true;
  };
}
