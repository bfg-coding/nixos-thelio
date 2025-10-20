{ config, pkgs, unstable, inputs, stylesheet, ... }:

{

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "justin";
  home.homeDirectory = "/home/justin";

  # Basic configuration
  home.stateVersion = "25.05"; # Adjust to match your NixOS version

  # add local scripts to path
  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ./modules/editors
    ./modules/development
    ./modules/rofi
    ./modules/hyprland
    ./modules/niri
    ./modules/waybar
    ./modules/yazi
    ./modules/zsh
    ./modules/zellij
    ./modules/swaylock
    ./modules/gtk
    ./modules/terminal/ghostty.nix
  ];

  # Packages to install
  home.packages = with pkgs; [
    # Basic utilities
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    tokei
    go-task

    # Social
    vesktop # discord client
    signal-desktop

    # Work
    slack
    google-chrome

    # Terminal Tools
    yazi

    # System tools
    cosmic-files

    # Productivity
    obsidian

    # Development tools
    helix # Helix editor
  ] ++ [
    # Add Zen Browser from the flake
    inputs.zen-browser.packages.${pkgs.system}.default
  ] ++ (with unstable; [
    zed-editor
  ]);

  # SSH setup
  services.ssh-agent.enable = true;


  # Configure SSH client declaratively
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";

    # Declarative SSH config
    matchBlocks = {
      # Work servers
      "ssh.dev.azure.com" = {
        identityFile = "~/.ssh/stg_azureDevops";
        user = "git";
      };

      # Personal repos
      "github.com" = {
        identityFile = "~/.ssh/bfg_github";
        user = "git";
      };

      # Default for all hosts
      "*" = {
        identitiesOnly = true;
      };
    };
  };

  # XDG configuration for default applications
  xdg = {
    enable = true;

    # Set cosmic-files as default file manager using the correct desktop file name
    mimeApps = {
      enable = true;

      defaultApplications = {
        # Directory/folder handling
        "inode/directory" = [ "com.system76.CosmicFiles.desktop" ];
        "application/x-directory" = [ "com.system76.CosmicFiles.desktop" ];

        # File manager protocol (used by browsers for "download" folder links)
        "x-scheme-handler/file" = [ "com.system76.CosmicFiles.desktop" ];

        # Additional file manager associations
        "application/x-nautilus-link" = [ "com.system76.CosmicFiles.desktop" ];

        # Browser Default
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-scheme-handler/about" = "brave-browser.desktop";
        "x-scheme-handler/unknown" = "brave-browser.desktop";
      };

      # Backup associations
      associations.added = {
        "inode/directory" = [ "com.system76.CosmicFiles.desktop" ];
        "application/x-directory" = [ "com.system76.CosmicFiles.desktop" ];
        "x-scheme-handler/file" = [ "com.system76.CosmicFiles.desktop" ];
      };
    };
  };

  # Lazygit
  programs.lazygit = {
    enable = true;
  };

  # Configure Dunst for notifications
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "10x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "#8AADF4";
        separator_color = "frame";
      };

      urgency_normal = {
        background = "#303446";
        foreground = "#C6D0F5";
        timeout = 10;
      };
    };
  };
}
