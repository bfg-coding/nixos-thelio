# My NixOS Configuration

*Generated on May 14, 2025*

## Table of Contents

- [README.md](#README.md)
- [configuration.nix](#configuration.nix)
- [flake.nix](#flake.nix)
- [hardware-configuration.nix](#hardware-configuration.nix)
- [home.nix](#home.nix)
- [modules/development/default.nix](#modulesdevelopmentdefault.nix)
- [modules/development/languages/default.nix](#modulesdevelopmentlanguagesdefault.nix)
- [modules/development/languages/go.nix](#modulesdevelopmentlanguagesgo.nix)
- [modules/development/languages/rust.nix](#modulesdevelopmentlanguagesrust.nix)
- [modules/development/lsp.nix](#modulesdevelopmentlsp.nix)
- [modules/editors/default.nix](#moduleseditorsdefault.nix)
- [modules/editors/helix/default.nix](#moduleseditorshelixdefault.nix)
- [modules/editors/helix/themes/default.nix](#moduleseditorshelixthemesdefault.nix)
- [modules/hyprland/binds.nix](#moduleshyprlandbinds.nix)
- [modules/hyprland/config.nix](#moduleshyprlandconfig.nix)
- [modules/hyprland/default.nix](#moduleshyprlanddefault.nix)
- [modules/hyprland/rules.nix](#moduleshyprlandrules.nix)
- [modules/rofi/default.nix](#modulesrofidefault.nix)
- [modules/rofi/themes/cyberpunk.nix](#modulesrofithemescyberpunk.nix)
- [modules/rofi/themes/default.nix](#modulesrofithemesdefault.nix)
- [modules/waybar/default.nix](#moduleswaybardefault.nix)
- [modules/yazi/default.nix](#modulesyazidefault.nix)
- [modules/zellij/default.nix](#moduleszellijdefault.nix)
- [modules/zsh/default.nix](#moduleszshdefault.nix)
- [modules/zsh/starship.nix](#moduleszshstarship.nix)
- [nixos-config-summary.md](#nixos-config-summary.md)

## Overview

This document contains a comprehensive overview of my NixOS configuration files.

## README.md

```md
# TODO List
- [ ] work with claude on building a current understanding of my sysstem
- [ ] build a proper readme based on that integration work wtih claude

```

## configuration.nix

```nix
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-framework"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # XDG Portal for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # Enable sound with Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Disable PulseAudio in favor of Pipewire
  services.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Shells
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.justin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  # programs.firefox.enable = true;

  # Enable Wayland and Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable the display manager (required to start Hyprland)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Theme = {
        Current = "sugar-dark";
        CursorTheme = "future-cursors";
        Font = "JetBrains Mono Nerd Font";
      };
      General = {
        DisplayServer = "wayland";
        InputMethod = "";
      };
    };
  };

  # Enable polkit for privilege escalation dialogs
  security.polkit.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git

    # Browsers
    brave

    # Hyprland tools
    waybar # Status bar
    rofi-wayland # Application launcher
    dunst # Notification daemon
    libnotify # Notification library
    swww # Wallpaper daemon
    wl-clipboard # Clipboard manager
    grim # Screenshot utility
    slurp # Screen region selection
    brightnessctl # Brightness control
    pamixer # Volume control
    networkmanagerapplet # Network manager tray

    # SDDM
    sddm-sugar-dark
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtmultimedia
  ];

  # Environment variables
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}


```

## flake.nix

```nix
{
  description = "NixOS and Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "justin";
    in
    {
      nixosConfigurations = {
        nixos-framework = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit inputs;
                  unstable = import nixpkgs-unstable {
                    system = "x86_64-linux";
                    config.allowUnfree = false;
                  };
                };
                users.${username} = import ./home.nix;
              };
            }
          ];
        };
      };
    };
}

```

## hardware-configuration.nix

```nix
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b0ae9b81-0c5e-44b9-a0f5-d77d84274d2e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AE49-1306";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/7090b276-a238-4ff9-88e4-1bcd30aad502"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

```

## home.nix

```nix
{ config, pkgs, unstable, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "justin";
  home.homeDirectory = "/home/justin";

  # Basic configuration
  home.stateVersion = "24.11"; # Adjust to match your NixOS version

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  imports = [
    ./modules/editors
    ./modules/development
    ./modules/rofi
    ./modules/hyprland
    ./modules/waybar
    ./modules/yazi
    ./modules/zsh
    ./modules/zellij
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

    # Social
    vesktop # discord client

    # Terminal Tools
    yazi

    # Development tools
    zed-editor # Zed editor
    helix # Helix editor
    ghostty # Terminal emulator
  ] ++ (with unstable; [
    # Terminal Tools
    zellij
    lazygit
  ]);

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

```

## modules/development/default.nix

```nix
# modules/development/default.nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./languages
    ./lsp.nix
  ];

  # Add core development libraries and tools
  home.packages = with pkgs; [
    # C/C++ toolchain (essential for many build processes)
    gcc
    binutils
    gnumake

    # Build tools
    pkg-config
    cmake

    # Common development libraries
    openssl.dev
    zlib.dev
  ];

  # Set environment variables for finding libraries
  home.sessionVariables = {
    # OpenSSL configuration
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";

    # PKG_CONFIG configuration (simple, direct approach)
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # Add to shell initialization scripts
  programs.bash.initExtra = lib.mkIf config.programs.bash.enable ''
    # Development environment variables
    export OPENSSL_DIR="${pkgs.openssl.dev}"
    export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
    export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
    export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
  '';

  programs.zsh.initExtra = lib.mkIf config.programs.zsh.enable ''
    # Development environment variables
    export OPENSSL_DIR="${pkgs.openssl.dev}"
    export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
    export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
    export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
  '';
}

```

## modules/development/languages/default.nix

```nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./rust.nix
    ./go.nix
  ];

  # Install common development tools
  home.packages = with pkgs;
    [
      # Nix tooling
      nixpkgs-fmt
      nil # Nix Language Server
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
    };
  };
}

```

## modules/development/languages/go.nix

```nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Golang
    go
    gopls # Go language server
    delve # Go debugger
    golangci-lint # Linter
    gotools # Contains goimports and other golang tooling
  ];

  # Helix Configurations
  programs.helix.languages = {
    language = [
      {
        name = "go";
        auto-format = true;
        formatter = { command = "${pkgs.gotools}/bin/goimports"; };
        language-servers = [ "gopls" ];
      }
    ];
    language-server = {
      gopls = {
        command = "${pkgs.gopls}/bin/gopls";
        args = [ "serve" "-rpc.trace" ];
        config = {
          usePlaceholders = true;
          analyses = {
            unusedparams = true;
            shadow = true;
            nilness = true;
            unusedwrite = true;
            useany = true;
          };
          # Enable staticcheck for additional linting
          staticcheck = true;
          # Make completion more fuzzy
          matcher = "fuzzy";
          # Support completion for packages not yet imported
          completeUnimported = true;
          # Add documentation to completion items
          completionDocumentation = true;
          # Organize imports when formatting
          gofumpt = true;
        };
      };
    };
  };
}

```

## modules/development/languages/rust.nix

```nix
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

```

## modules/development/lsp.nix

```nix
{ config, pkgs, lib, ... }:
{
  programs.helix.settings = {
    editor.lsp = {
      display-messages = true;
      display-inlay-hints = true;
    };
  };

  # LSP integration settings
  programs.helix.languages.language-server = {
    gopls = {
      config = {
        # Enhance editor experience
        semanticTokens = true;
        # Enable inlay hints (type hints, paramters names)
        hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
      # Improve memory usage limit for large projects
      memoryMode = "DegradeClosed";
    };
  };

  # Additional Go environment variables for proper module support
  home.sessionVariables = {
    # Enable Go modules by default
    GO111MODULE = "on";
    # Set common Go paths
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
  };
  
  # Extra packages specifically for Go development
  home.packages = with pkgs; [
    # Go test runner with colorized output
    gotestsum
    # Go code coverage tool
    go-tools # contains cover, callgraph, etc.
    # Go dependency management
    govulncheck
  ];
}

```

## modules/editors/default.nix

```nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./helix
    # Other editor modules if you add them later
  ];
}

```

## modules/editors/helix/default.nix

```nix
{ config, pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    
    # Core editor settings
    settings = {
      theme = "tokyonight";
      
      editor = {
        line-number = "relative";
        mouse = true;
        cursorline = true;
        color-modes = true;
        bufferline = "always";
        true-color = true;
        
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        
        statusline = {
          left = ["mode" "spinner" "file-name" "file-modification-indicator"];
          center = [];
          right = ["diagnostics" "selections" "position" "file-encoding"];
        };
        
        indent-guides.render = true;
        lsp.display-messages = true;
      };
    };
  };
}

```

## modules/editors/helix/themes/default.nix

```nix
{ config, pkgs, lib, ... }:
{}

```

## modules/hyprland/binds.nix

```nix
# modules/hyprland/binds.nix - Hyprland key and mouse bindings
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Define the mod key ($mod)
    "$mod" = "SUPER";

    # Application bindings
    bind = [
      # Terminal
      "$mod, T, exec, ${pkgs.ghostty}/bin/ghostty"

      # Rofi launcher with cyberpunk theme
      "$mod, SPACE, exec, rofi -theme cyberpunk -show drun"

      # Window management
      "$mod, Q, killactive,"
      "$mod, M, exit,"
      "$mod, V, togglefloating,"
      "$mod, F, fullscreen,"

      # Window focus
      "$mod, left, movefocus, l"
      "$mod, h, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, l, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, k, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, j, movefocus, d"

      # Workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Shift workspace
      "$mod CONTROL, h, workspace, m-1"
      "$mod CONTROL, l, workspace, m+1"

      # Shift windwo workspace
      "$mod SHIFT, h, movetoworkspace, r-1"
      "$mod SHIFT, l, movetoworkspace, r+1"

      # Move windows to workspaces
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Screenshot bindings
      "$mod, S, exec, grim -g \"$(slurp)\" - | wl-copy"
      "$mod SHIFT, S, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

      # Volume control
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86AudioMute, exec, pamixer -t"

      # Brightness control
      ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    ];

    # Mouse bindings
    bindm = [
      # Move/resize windows with mod key + LMB/RMB drag
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}

```

## modules/hyprland/config.nix

```nix
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration
    monitor = ",preferred,auto,1";
    
    # Execute applications at launch
    exec-once = [
      "dunst"
      "${pkgs.swww}/bin/swww init"
    ];
    
    # General settings
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee)";
      "col.inactive_border" = "rgba(595959aa)";
      layout = "dwindle";
    };
    
    # Decoration settings
    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
      
      # Shadow configuration
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3; 
        color = "rgba(1a1a1aee)";
      };
    };
    
    # Animation settings
    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
    
    # Layout settings
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
    
    # Cursor settings
    cursor = {
      inactive_timeout = 5; # Hide cursor after 5 seconds of inactivity
    };
    
    # Input settings
    input = {
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = 0.5; # Mouse sensitivity (0.0 - 1.0)
      touchpad = {
        natural_scroll = true;
        disable_while_typing = true;
        tap-to-click = true;
      };
    };
    
    # Window rules & Layer rules
    layerrule = [
      "blur, rofi"         # Apply blur to Rofi launcher
      "ignorezero, rofi"   # Properly handle transparency
      "blur, waybar"       # Apply blur to Waybar
    ];
  };
}

```

## modules/hyprland/default.nix

```nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./config.nix    # Hyprland configuration settings
    ./binds.nix     # Keyboard and mouse bindings
    ./rules.nix     # Window rules and layerrules
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    xwayland.enable = true;
  };

  # Install necessary packages for the Hyprland environment
  home.packages = with pkgs; [
    waybar           # Status bar
    dunst            # Notification daemon
    libnotify        # Notification library
    swww             # Wallpaper daemon
    wl-clipboard     # Clipboard manager
    grim             # Screenshot utility
    slurp            # Screen region selection
    brightnessctl    # Brightness control
    pamixer          # Volume control
    networkmanagerapplet # Network manager tray
  ];
}

```

## modules/hyprland/rules.nix

```nix
{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    # Window rules
    windowrule = [
      # Firefox Picture-in-Picture always on top
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      
      # Media viewers as floating windows
      "float, class:^(imv)$"
      "float, class:^(mpv)$"
      
      # Image viewers centered with specific size
      "center, class:^(imv)$"
      "size 75% 75%, class:^(imv)$"
      
      # File browsers with specific opacity
      "opacity 0.95, class:^(thunar)$"
      
      # Notifications on specific workspace
      "workspace special silent, title:^(.*Notification.*)$"
      
      # Dialog windows floating
      "float, title:^(.*Dialog.*)$"
      "float, title:^(.*Settings.*)$"
      
      # Terminal opacity
      "opacity 0.95, class:^(ghostty)$"
      
      # IDEs
      "opacity 0.98, class:^(code)$"
      "opacity 0.98, class:^(zed)$"
    ];
    
    # Layer rules for proper blur and transparency
    layerrule = [
      "blur, rofi"
      "blur, waybar"
    ];
        
    # Window rules (without blur which isn't valid)
    windowrulev2 = [
        # Terminal opacity settings
      "opacity 0.95, class:^(ghostty)$"
      "opacity 0.95, class:^(kitty)$"
  
      # Rofi specific rules
      "noborder, class:^(rofi)$"
    ];
  };
}

```

## modules/rofi/default.nix

```nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./themes # Import all themes from the themes directory
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;  # Use rofi-wayland for Hyprland compatibility
    cycle = true;
    location = "center";
    terminal = "${pkgs.ghostty}/bin/ghostty"; # Using ghostty from your configuration
    
    # Adding some useful plugins
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];
    
    # Set active theme - can be changed to any theme in the themes directory
    theme = "cyberpunk";
    
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      icon-theme = "cyberpunk";
      drun-display-format = "{name}";
      disable-history = false;
      sidebar-mode = false;
      
      # Cyberpunk window and interface settings
      window-format = "{w} · {c} · {t}";
      fullscreen = false;
      fake-transparency = false;
      transparency = true;
      
      # Keyboard navigation
      kb-remove-to-eol = "";
      kb-accept-entry = "Return,KP_Enter";
      kb-row-up = "Up,Control+k";
      kb-row-down = "Down,Control+j";
      
      # Animation and appearance
      animation = true;
      animation-length = 300;
      hide-scrollbar = true;
      
      # Application search settings
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      case-sensitive = false;
    };
  };
}

```

## modules/rofi/themes/cyberpunk.nix

```nix
# modules/rofi/themes/cyberpunk.nix - Cyberpunk theme configuration
{ config, pkgs, lib, ... }:

{
  # Place the theme in the correct location for Rofi to find it
  xdg.dataFile."rofi/themes/cyberpunk.rasi".text = ''
    /* Global properties */
    * {
      background:     #091833;
      background-alt: #133e7c;
      foreground:     #ffffff;
      selected:       #0abdc6;
      accent:         #ea00d9;
      urgent:         #ff0000;
      
      font: "JetBrainsMono Nerd Font 12";
      
      /* Set transparency here if desired - 95% opaque */
      background-color: rgba(9, 24, 51, 0.95);
      text-color: @foreground;
    }

    window {
      transparency: "real";
      border: 3px;
      border-color: @selected;
      border-radius: 2px;
      height: 520px;
      width: 800px;
      location: north;
      anchor: north;
      y-offset: 20px;
    }

    mainbox {
      children: [inputbar, message, listview, mode-switcher];
      padding: 0px;
      background-color: @background;
      border: 0;
    }

    /* Input bar */
    inputbar {
      children: [prompt, entry];
      background-color: @background;
      border-radius: 10px;
      margin: 20px 20px 10px 20px;
      padding: 2px;
    }

    prompt {
      background-color: transparent;
      border: 2px;
      border-color: @selected;
      border-radius: 0px;
      margin: 0px 0px 0px 0px;
      padding: 8px 12px;
      text-color: @selected;
      text-transform: uppercase;
    }

    entry {
      background-color: @background;
      margin: 0px 0px 0px 10px;
      padding: 6px;
      text-color: @foreground;
      placeholder: "Search...";
      placeholder-color: rgba(255, 255, 255, 0.5);
    }

    /* Message */
    message {
      background-color: @background-alt;
      margin: 0px 20px 10px 20px;
      padding: 0px;
      border-radius: 8px;
    }

    textbox {
      padding: 10px;
      text-color: @selected;
      background-color: @background;
    }

    /* List view */
    listview {
      background-color: @background;
      border: 0px;
      columns: 1;
      fixed-height: true;
      dynamic: true;
      lines: 10;
      margin: 0px 20px 10px 20px;
      padding: 0px 0px 0px 0px;
      scrollbar: true;
      spacing: 2px;
    }

    scrollbar {
      background-color: @background;
      handle-color: @selected;
      handle-width: 8px;
      border-radius: 10px;
    }

    element {
      background-color: @background;
      padding: 8px;
      spacing: 5px;
    }

    element-icon {
      size: 25px;
      background-color: inherit;
    }

    element-text {
      background-color: inherit;
      text-color: inherit;
      vertical-align: 0.5;
    }

    element selected {
      background-color: @background;
      border-left: 3px;
      border-color: @accent;
      padding-left: 12px;
      text-color: @selected;
    }

    element normal.urgent, element alternate.urgent {
      background-color: @background;
      text-color: @urgent;
    }

    element normal.active, element alternate.active {
      background-color: @background;
      text-color: @accent;
    }

    /* Mode switcher */
    mode-switcher {
      spacing: 0;
      margin: 0px 20px 20px 20px;
      background-color: @background;
    }

    button {
      padding: 10px;
      background-color: @background-alt;
      text-color: @foreground;
    }

    button selected {
      background-color: @background;
      text-color: @accent;
      border: 2px;
      border-radius: 8px;
      border-color: @selected;
    }
  '';
}

```

## modules/rofi/themes/default.nix

```nix
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

```

## modules/waybar/default.nix

```nix
{ config, pkgs, lib, ... }:

{
  # Enable and configure Waybar
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        margin-top = 6;
        margin-left = 8;
        margin-right = 8;
        
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["network" "pulseaudio" "cpu" "memory" "battery" "tray"];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            default = "";
            active = "";
          };
          on-click = "activate";
          sort-by-number = true;
        };
        
        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };
        
        "clock" = {
          format = "{:%I:%M %p}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        
        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "󰈂 Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };
        
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pamixer -t";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
        };
        
        "cpu" = {
          interval = 10;
          format = " {usage}%";
          max-length = 10;
          on-click = "${pkgs.btop}/bin/btop";
        };
        
        "memory" = {
          interval = 30;
          format = " {}%";
          max-length = 10;
          on-click = "${pkgs.btop}/bin/btop";
        };
        
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = ["" "" "" "" ""];
          format-charging = " {capacity}%";
        };
        
        "tray" = {
          icon-size = 18;
          spacing = 10;
        };
      };
    };
    
    # Waybar style settings
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans", sans-serif;
        font-size: 12pt;
        border: none;
        border-radius: 0;
      }
      
      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: 0.5s;
        border-radius: 8px;
      }
      
      window#waybar.hidden {
        opacity: 0.5;
      }
      
      #workspaces {
        border-radius: 8px;
        margin-right: 6px;
        padding: 0 6px;
      }
      
      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #cdd6f4;
        border-radius: 6px;
        transition: all 0.3s ease;
      }
      
      #workspaces button:hover {
        box-shadow: inset 0 -3px #ffffff;
      }
      
      #workspaces button.active {
        background-color: #7f849c;
        color: #1e1e2e;
      }
      
      #workspaces button.urgent {
        background-color: #f38ba8;
        color: #1e1e2e;
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #pulseaudio,
      #network,
      #tray {
        padding: 0 10px;
        margin: 0 5px;
        background-color: rgba(60, 60, 80, 0.5);
        border-radius: 8px;
      }
      
      /* Module-specific styling */
      #battery.warning {
        background-color: #f9e2af;
        color: #1e1e2e;
      }
      
      #battery.critical {
        background-color: #f38ba8;
        color: #1e1e2e;
      }
      
      #battery.charging {
        background-color: #a6e3a1;
        color: #1e1e2e;
      }
      
      label:focus {
        background-color: #1e1e2e;
      }
      
      #tray {
        background-color: rgba(60, 60, 80, 0.5);
      }
      
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }
    '';
  };
}

```

## modules/yazi/default.nix

```nix
{ config, pkgs, lib, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
}

```

## modules/zellij/default.nix

```nix
{ config, pkgs, lib, ... }:

{
  programs.zellij = {
    enable = true;
  };
}

```

## modules/zsh/default.nix

```nix
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
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos-framework";
    };
    sessionVariables = {
      GOPATH = "$HOME/.go";
    };
  };
}

```

## modules/zsh/starship.nix

```nix
{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # FIRST LINE/ROW: Info & Status

      # First param ─┌
      username = {
        format = " [╭─$user]($style)@";
        style_user = "bold #0abdc6"; # Neon cyan from your cyberpunk theme
        style_root = "bold #0abdc6";
        show_always = true;
      };

      # Second param
      hostname = {
        format = "[$hostname]($style) in ";
        style = "bold dimmed #133e7c"; # Light blue accent
        trim_at = "-";
        ssh_only = false;
        disabled = false;
      };

      # Third param
      directory = {
        style = "#ea00d9"; # Neon magenta
        truncation_length = 0;
        truncate_to_repo = true;
        truncation_symbol = "repo: ";
      };

      # Before all the version info
      git_status = {
        style = "red";
        ahead = "⇡$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        behind = "⇣$count";
        deleted = "x";
      };

      # Last param in the first line/row
      cmd_duration = {
        min_time = 1;
        format = "took [$duration]($style)";
        disabled = false;
      };

      # SECOND LINE/ROW: Prompt

      # Battery indicators (disabled but configured)
      battery = {
        full_symbol = " ";
        charging_symbol = " ";
        discharging_symbol = " ";
        disabled = true;

        display = [
          {
            threshold = 15;
            style = "bold red";
            disabled = true;
          }
          {
            threshold = 50;
            style = "bold yellow";
            disabled = true;
          }
          {
            threshold = 80;
            style = "bold green";
            disabled = true;
          }
        ];
      };

      # Time (disabled but configured)
      time = {
        format = " 🕙 $time($style)\n";
        time_format = "%T";
        style = "bright-white";
        disabled = true;
      };

      # Prompt character
      character = {
        success_symbol = " [╰─λ](bold #0abdc6)"; # Neon cyan
        error_symbol = " [×](bold #ea00d9)"; # Neon magenta for errors
      };

      # Status indicator
      status = {
        symbol = "🔴";
        format = "[\\[$symbol$status_common_meaning$status_signal_name$status_maybe_int\\]]($style)";
        map_symbol = true;
        disabled = false;
      };

      # SYMBOLS FOR PROGRAMMING LANGUAGES AND TOOLS
      aws.symbol = " ";
      conda.symbol = " ";
      dart.symbol = " ";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      git_branch = {
        symbol = " ";
        style = "#711c91"; # Neon purple for git branch
      };
      golang.symbol = " ";
      hg_branch.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      nim.symbol = " ";
      nix_shell = {
        symbol = " ";
        style = "#0abdc6"; # Neon cyan for nix shells
      };
      nodejs.symbol = " ";
      package.symbol = " ";
      perl.symbol = " ";
      php.symbol = " ";
      python.symbol = " ";
      ruby.symbol = " ";
      rust.symbol = " ";
      swift.symbol = "ﯣ ";
    };
  };
}

```

## nixos-config-summary.md

```md

```

