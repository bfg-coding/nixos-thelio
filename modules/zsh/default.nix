{ config, pkgs, unstable, ... }:

{
  imports = [
    ./starship.nix
  ];

  # ZSH configuration
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" ];
    };
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/.nixos_config#nixos-thelio";
      upgrade = "sudo nix flake update && nrs";
      lg = "lazygit";
    };
    initContent = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
